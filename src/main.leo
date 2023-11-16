program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; 13], at: field) -> field {
        let eval: field = 0field;

        eval = eval * at + coeff[12u8];
        eval = eval * at + coeff[11u8];
        eval = eval * at + coeff[10u8];
        eval = eval * at + coeff[9u8];
        eval = eval * at + coeff[8u8];
        eval = eval * at + coeff[7u8];
        eval = eval * at + coeff[6u8];
        eval = eval * at + coeff[5u8];
        eval = eval * at + coeff[4u8];
        eval = eval * at + coeff[3u8];
        eval = eval * at + coeff[2u8];
        eval = eval * at + coeff[1u8];
        eval = eval * at + coeff[0u8];

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[field; 2]; 13]) -> field {
      let secret: field = 0field;
      for i: u8 in 0u8..13u8 {
        let evaly: field = evals[i][1u8];
        for j: u8 in 0u8..13u8 {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evals[i][0u8]) : evals[j][0u8]).inv();
        }
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[[field; 2]; 32]; 2] {
      // a bit of entropy for the coefficients, derived from secret and the caller
      let seed: field = Poseidon2::hash_to_field(secret) * Poseidon2::hash_to_field(self.caller as field);

      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(seed);
      let coeff_2: field = Poseidon2::hash_to_field(coeff_1);
      let coeff_3: field = Poseidon2::hash_to_field(coeff_2);
      let coeff_4: field = Poseidon2::hash_to_field(coeff_3);
      let coeff_5: field = Poseidon2::hash_to_field(coeff_4);
      let coeff_6: field = Poseidon2::hash_to_field(coeff_5);
      let coeff_7: field = Poseidon2::hash_to_field(coeff_6);
      let coeff_8: field = Poseidon2::hash_to_field(coeff_7);
      let coeff_9: field = Poseidon2::hash_to_field(coeff_8);
      let coeff_10: field = Poseidon2::hash_to_field(coeff_9);
      let coeff_11: field = Poseidon2::hash_to_field(coeff_10);
      let coeff_12: field = Poseidon2::hash_to_field(coeff_11);

      // represent coeffs as an array for horner
      let coeffs: [field; 13] = [coeff_0, coeff_1, coeff_2, coeff_3, coeff_4, coeff_5, coeff_6, coeff_7, coeff_8, coeff_9, coeff_10, coeff_11, coeff_12];

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
          [11field, horner(coeffs, 11field)],
          [12field, horner(coeffs, 12field)],
          [13field, horner(coeffs, 13field)],
          [14field, horner(coeffs, 14field)],
          [15field, horner(coeffs, 15field)],
          [16field, horner(coeffs, 16field)],
          [17field, horner(coeffs, 17field)],
          [18field, horner(coeffs, 18field)],
          [19field, horner(coeffs, 19field)],
          [20field, horner(coeffs, 20field)],
          [21field, horner(coeffs, 21field)],
          [22field, horner(coeffs, 22field)],
          [23field, horner(coeffs, 23field)],
          [24field, horner(coeffs, 24field)],
          [25field, horner(coeffs, 25field)],
          [26field, horner(coeffs, 26field)],
          [27field, horner(coeffs, 27field)],
          [28field, horner(coeffs, 28field)],
          [29field, horner(coeffs, 29field)],
          [30field, horner(coeffs, 30field)],
          [31field, horner(coeffs, 31field)],
          [32field, horner(coeffs, 32field)]
        ],
        [
          [33field, horner(coeffs, 33field)],
          [34field, horner(coeffs, 34field)],
          [35field, horner(coeffs, 35field)],
          [36field, horner(coeffs, 36field)],
          [37field, horner(coeffs, 37field)],
          [38field, horner(coeffs, 38field)],
          [39field, horner(coeffs, 39field)],
          [40field, horner(coeffs, 40field)],
          [41field, horner(coeffs, 41field)],
          [42field, horner(coeffs, 42field)],
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
