program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; 4], at: field) -> field {
        let eval: field = 0field;

        eval = eval * at + coeff[3u8];
        eval = eval * at + coeff[2u8];
        eval = eval * at + coeff[1u8];
        eval = eval * at + coeff[0u8];

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[field; 2]; 4]) -> field {
      let secret: field = 0field;
      for i: u8 in 0u8..4u8 {
        let evaly: field = evals[i][1u8];
        for j: u8 in 0u8..4u8 {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evals[i][0u8]) : evals[j][0u8]).inv();
        }
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[[field; 2]; 32]; 1] {
      // a bit of entropy for the coefficients, derived from secret and the caller
      let seed: field = Poseidon2::hash_to_field(secret) * Poseidon2::hash_to_field(self.caller as field);

      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(seed);
      let coeff_2: field = Poseidon2::hash_to_field(coeff_1);
      let coeff_3: field = Poseidon2::hash_to_field(coeff_2);

      // represent coeffs as an array for horner
      let coeffs: [field; 4] = [coeff_0, coeff_1, coeff_2, coeff_3];

      return [
                [
          [1field, horner(coeffs, 1field)],
          [2field, horner(coeffs, 2field)],
          [3field, horner(coeffs, 3field)],
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
