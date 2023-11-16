program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [[field; 32]; 1], coeff_count: u8, at: field) -> field {
        let eval: field = 0field;

        eval = eval * at + coeff[0u8][2u8];
        eval = eval * at + coeff[0u8][1u8];
        eval = eval * at + coeff[0u8][0u8];

        return eval;
    }

    // recover the secret from k evaluations
    transition recover(evals: [[[field; 2]; 32]; 1]) -> field {
      let secret: field = 0field;
      for l: u8 in 0u8..1u8 {
        for i: u8 in 0u8..3u8 {
          let evaly: field = evals[l][i][1u8];
          for j: u8 in 0u8..3u8 {
            evaly *= evals[l][j][0u8] * (i != j ? (evals[l][j][0u8] - evals[l][i][0u8]) : evals[l][j][0u8]).inv();
          }
          secret += evaly;
        }
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[[field; 2]; 32]; 1] {
      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(coeff_0);
      let coeff_2: field = Poseidon2::hash_to_field(coeff_1);

      // represent coeffs as an array
      let coeffs: [[field; 32]; 1] = [
             [
      coeff_0,
      coeff_1,
      coeff_2,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field,
      0field
      ]

      ];

      return [
             [
      [1field, horner(coeffs, 3u8, 1field)],
      [2field, horner(coeffs, 3u8, 2field)],
      [3field, horner(coeffs, 3u8, 3field)],
      [4field, horner(coeffs, 3u8, 4field)],
      [5field, horner(coeffs, 3u8, 5field)],
      [6field, horner(coeffs, 3u8, 6field)],
      [7field, horner(coeffs, 3u8, 7field)],
      [8field, horner(coeffs, 3u8, 8field)],
      [9field, horner(coeffs, 3u8, 9field)],
      [10field, horner(coeffs, 3u8, 10field)],
      [11field, horner(coeffs, 3u8, 11field)],
      [12field, horner(coeffs, 3u8, 12field)],
      [13field, horner(coeffs, 3u8, 13field)],
      [14field, horner(coeffs, 3u8, 14field)],
      [15field, horner(coeffs, 3u8, 15field)],
      [16field, horner(coeffs, 3u8, 16field)],
      [17field, horner(coeffs, 3u8, 17field)],
      [18field, horner(coeffs, 3u8, 18field)],
      [19field, horner(coeffs, 3u8, 19field)],
      [20field, horner(coeffs, 3u8, 20field)],
      [21field, horner(coeffs, 3u8, 21field)],
      [22field, horner(coeffs, 3u8, 22field)],
      [23field, horner(coeffs, 3u8, 23field)],
      [24field, horner(coeffs, 3u8, 24field)],
      [25field, horner(coeffs, 3u8, 25field)],
      [26field, horner(coeffs, 3u8, 26field)],
      [27field, horner(coeffs, 3u8, 27field)],
      [28field, horner(coeffs, 3u8, 28field)],
      [29field, horner(coeffs, 3u8, 29field)],
      [30field, horner(coeffs, 3u8, 30field)],
      [31field, horner(coeffs, 3u8, 31field)],
      [32field, horner(coeffs, 3u8, 32field)]
      ]

      ];

    }
  
  }
