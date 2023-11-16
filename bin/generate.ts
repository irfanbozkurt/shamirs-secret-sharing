import { getBitSize } from "./utils";

/**
 * Generates an Aleo program that does Shamir Secret Sharing for (k, n) threshold setting.
 *
 * @param k degree of polynomial
 * @param n number of evaluation point
 * @returns the Aleo program to do Shamir Secret Sharing
 */
export function generateCircuit(k: number, n: number) {
  // number of bits needed for index `k` to iterate over the polynomial
  // TODO: we are probably ok just with u8, due to array size limit of 32
  const bk = getBitSize(k);

  // Aleo only supports arrays of size up to 32.
  // to make splitting to more pieces possible, we need nested arrays.
  const numChunks = Math.ceil(n / 32);

  // each coefficient is the hash of the previous one
  // except for the first one, which is seeded
  // the zeroth one is equal to `secret`
  const coefficients = Array.from(
    { length: k - 2 },
    (_, i) => `      let coeff_${i + 2}: field = Poseidon2::hash_to_field(coeff_${i + 1});`,
  ).join("\n");

  // horner must use a reverse for-loop, which Aleo does not allow, so we write them one-by-one.
  const hornerSteps = Array.from({ length: k }, (_, i) => `        eval = eval * at + coeff[${k - i - 1}u${bk}];`).join(
    "\n",
  );

  // an array of coefficients, for horner method argument
  const coefficientsArray = Array.from({ length: k }, (_, i) => `coeff_${i}`).join(", ");

  // an array of evaluations with zeros padded to have a multiple of 32 elements
  const evaluations = Array.from({ length: n }, (_, i) => `[${i + 1}field, horner(coeffs, ${i + 1}field)]`);
  const numZeros = numChunks * 32 - n;
  const zeros = numZeros === 32 ? [] : Array.from({ length: numZeros }, (_, i) => `[0field, 0field]`);
  const paddedEvaluations = evaluations.concat(zeros);
  if (paddedEvaluations.length % 32 !== 0) {
    throw new Error("expected padded points to have 32x elements.");
  }

  // array of evaluations chunked into arrays of 32 points
  const evaluationPoints = Array.from({ length: numChunks }, (_, i) => {
    const chunkEvals = paddedEvaluations.slice(i * 32, (i + 1) * 32);
    return chunkEvals.map((e) => "          " + e).join(",\n");
  })
    .map(
      (e) => `        [
${e}
        ]`,
    )
    .join(",\n");

  return `program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; ${k}], at: field) -> field {
        let eval: field = 0field;

${hornerSteps}

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[field; 2]; ${k}]) -> field {
      let secret: field = 0field;
      for i: u${bk} in 0u${bk}..${k}u${bk} {
        let evaly: field = evals[i][1u8];
        for j: u${bk} in 0u${bk}..${k}u${bk} {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evals[i][0u8]) : evals[j][0u8]).inv();
        }
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    // to return more than 32 points, we have an array of 32 points instead of just an array
    // for this reason, we have to do zero-padding for the points beyond the n'th evaluation
    transition split(secret: field) -> [[[field; 2]; 32]; ${numChunks}] {
      // a bit of entropy for the coefficients, derived from secret and the caller
      let seed: field = Poseidon2::hash_to_field(secret) * Poseidon2::hash_to_field(self.caller as field);

      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(seed);
${coefficients}

      // represent coeffs as an array for horner
      let coeffs: [field; ${k}] = [${coefficientsArray}];

      return [
        ${evaluationPoints}
      ];

    }
  
  }
`;
}
