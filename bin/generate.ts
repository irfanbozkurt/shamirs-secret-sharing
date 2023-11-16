/**
 * Finds the number of bytes w.r.t Aleo data-types to fit the index number.
 * @param x number
 * @returns bits of 8 to fit the number
 */
function getBitSize(x: number): 8 | 16 | 32 | 64 | 128 {
  const b = Math.ceil(Math.log2(x));
  for (const b8 of [8, 16, 32, 64, 128] as const) {
    if (b <= b8) {
      return b8;
    }
  }
  throw new Error("cant have 128-bit index");
}

/**
 * Generates an Aleo program that does Shamir Secret Sharing for (n, k) threshold.
 *
 * @param n number of evaluation point
 * @param k degree of polynomial
 * @param b bitsize for n (TODO: decide this based on `n`)
 * @returns the Aleo program to do Shamir Secret Sharing
 */
async function makeAleo(n: number, k: number) {
  // number of bits needed for index `k` to iterate over the polynomial
  const bk = getBitSize(k);

  // Aleo supports arrays of size up to 32.
  // To make splitting to more pieces possible, we need nested arrays.
  const splitArrCount = Math.ceil(n / 32); // count of arrays of size 32

  const recoverArrCount = Math.ceil(k / 32); // count of arrays of size 32

  await Bun.write(
    `./src/main.leo`,
    `program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; ${k}], at: field) -> field {
        let eval: field = 0field;

${Array.from(
  { length: k },
  (_, i) => `        eval = eval * at + coeff[${k - i - 1}u${bk}];`
).join("\n")}

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[[field; 2]; ${k}]; ${recoverArrCount}]) -> field {
      let secret: field = 0field;
      for l: u8 in 0u8..${recoverArrCount}u8 {
        for i: u${bk} in 0u${bk}..${k}u${bk} {
          let evaly: field = evals[l][i][1u8];
          for j: u${bk} in 0u${bk}..${k}u${bk} {
            evaly *= evals[l][j][0u8] * (i != j ? (evals[l][j][0u8] - evals[l][i][0u8]) : evals[l][j][0u8]).inv();
          }
          secret += evaly;
        }
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[[field; 2]; 32]; ${splitArrCount}] {
      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
${Array.from(
  { length: k - 1 },
  (_, i) =>
    `      let coeff_${i + 1}: field = Poseidon2::hash_to_field(coeff_${i});`
).join("\n")}

      // represent coeffs as an array
      let coeffs: [field; ${k}] = [${Array.from(
      { length: k },
      (_, i) => `coeff_${i}`
    ).join(", ")}];

      return [
        ${Array.from({ length: 34 * splitArrCount }, (_, i) => {
          if (i % 34 == 0) return `     [\n`;
          if (i % 34 == 33)
            return `      ]${i == 34 * splitArrCount - 1 ? "" : ","}\n`;

          const fieldIdx = (i % 34) + Math.floor(i / 34) * 32;
          return `      [${fieldIdx}field, horner(coeffs, ${fieldIdx}field)]${
            i % 34 == 32 ? "" : ","
          }\n`;
        }).join("")}
      ];

    }
  
  }
`
  );

  await Bun.write(
    `./inputs/shamir.in`,
    `
[recover]
evals: [[[field; 2]; ${k}]; ${recoverArrCount}] = [

];
`
  );
}

if (import.meta.main) {
  console.log("Generating Shamir Secret Share for Aleo.");
  let N = 10; // number of evaluation points
  let K = 3; // degree of polynomial

  if (Bun.argv.length > 2)
    try {
      N = parseInt(Bun.argv[2]);
      if (N < 2)
        throw new Error(`You must split your secret to at least N=2 pieces`);
      K = N; // If user provided N but no K, fallback to K = N
    } catch (e) {
      console.error(`Please provide a valid integer for N. Error: ${e}`);
    }
  if (Bun.argv.length > 3)
    try {
      K = parseInt(Bun.argv[3]);
      if (K > N)
        throw new Error(`K cannot be > N, but you provided N=${N} and K=${K}`);
    } catch (e) {
      console.error(`Please provide a valid integer for K. Error: ${e}`);
    }

  await makeAleo(N, K);
}
