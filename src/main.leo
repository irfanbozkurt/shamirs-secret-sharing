program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; 3], at: field) -> field {
        let eval: field = 0field;

        eval = eval * at + coeff[2u8];
        eval = eval * at + coeff[1u8];
        eval = eval * at + coeff[0u8];

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[field; 2]; 3]) -> field {
      let secret: field = 0field;
      for i: u8 in 0u8..3u8 {
        let evaly: field = evals[i][1u8];
        for j: u8 in 0u8..3u8 {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evals[i][0u8]) : evals[j][0u8]).inv();
        }
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    // to return more than 32 points, we have an array of 32 points instead of just an array
    // for this reason, we have to do zero-padding for the points beyond the n'th evaluation
    transition split(secret: field) -> [[[field; 2]; 32]; 1] {
      // a bit of entropy for the coefficients, derived from secret and the caller
      let seed: field = Poseidon2::hash_to_field(secret) * Poseidon2::hash_to_field(self.caller as field);

      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(seed);
      let coeff_2: field = Poseidon2::hash_to_field(coeff_1);

      // represent coeffs as an array for horner
      let coeffs: [field; 3] = [coeff_0, coeff_1, coeff_2];

      return [
                [
          [1field, horner(coeffs, 1field)],
          [2field, horner(coeffs, 2field)],
          [3field, horner(coeffs, 3field)],
          [4field, horner(coeffs, 4field)],
          [5field, horner(coeffs, 5field)],
          [6field, horner(coeffs, 6field)],
          [7field, horner(coeffs, 7field)],
          [8field, horner(coeffs, 8field)],
          [9field, horner(coeffs, 9field)],
          [10field, horner(coeffs, 10field)],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field],
          [0field, 0field]
        ]
      ];

    }
  
  }
