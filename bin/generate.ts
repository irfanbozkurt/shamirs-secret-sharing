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
function makeAleo(n: number, k: number) {
  if (k < 2) {
    throw new Error("k must be greater than 2");
  }

  // number of bits needed for index `k` to iterate over the polynomial
  const bk = getBitSize(k);

  return `program shamir.aleo {

    // horner's method to evaluate a polynomial of k-1 degree
    inline horner(coeff: [field; ${k}], at: field) -> field {
        let eval: field = 0field;

${Array.from(
  { length: k },
  (_, i) => `        eval = eval * at + coeff[${k - i - 1}u${bk}];`
).join("\n")}

        return eval;
    }
  
    // recover the secret from k evaluations
    transition recover(evals: [[field; 2]; ${k}]) -> field {
      let secret: field = 0field;
      for i: u${bk} in 0u${bk}..${k}u${bk} {
        let evaly: field = evals[i][1u8];
        let evalx: field = evals[i][0u8];
  
        for j: u${bk} in 0u${bk}..${k}u${bk} {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evalx) : evals[j][0u8]).inv();
        }
  
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[field; 2]; ${n}] {
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
${Array.from(
  { length: n },
  (_, i) => `          [${i + 1}field, horner(coeffs, ${i + 1}field)]`
).join(",\n")}
      ];
    }
  
  }
  `;
}

if (import.meta.main) {
  console.log("Generating Shamir Secret Share for Aleo.");
  const N = 10; // number of evaluation points
  const K = 3; // degree of polynomial
  const code = makeAleo(N, K);
  const path = `./src/main.leo`;

  await Bun.write(path, code);
  console.log("Output to:", path);
}
