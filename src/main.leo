program shamir.aleo {

    // horner's method to evaluate a polynomial of degree k-1
    inline horner(coeff: [field; 32], at: field) -> field {
        let eval: field = 0field;

        eval = eval * at + coeff[31u8];
        eval = eval * at + coeff[30u8];
        eval = eval * at + coeff[29u8];
        eval = eval * at + coeff[28u8];
        eval = eval * at + coeff[27u8];
        eval = eval * at + coeff[26u8];
        eval = eval * at + coeff[25u8];
        eval = eval * at + coeff[24u8];
        eval = eval * at + coeff[23u8];
        eval = eval * at + coeff[22u8];
        eval = eval * at + coeff[21u8];
        eval = eval * at + coeff[20u8];
        eval = eval * at + coeff[19u8];
        eval = eval * at + coeff[18u8];
        eval = eval * at + coeff[17u8];
        eval = eval * at + coeff[16u8];
        eval = eval * at + coeff[15u8];
        eval = eval * at + coeff[14u8];
        eval = eval * at + coeff[13u8];
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
    transition recover(evals: [[field; 2]; 32]) -> field {
      let secret: field = 0field;
      for i: u8 in 0u8..32u8 {
        let evaly: field = evals[i][1u8];
        for j: u8 in 0u8..32u8 {
          evaly *= evals[j][0u8] * (i != j ? (evals[j][0u8] - evals[i][0u8]) : evals[j][0u8]).inv();
        }
        secret += evaly;
      }
      return secret;
    }
  
    // split a secret to n points, using k coefficients for a (k-1) degree polynomial
    transition split(secret: field) -> [[[field; 2]; 32]; 3] {
      // compute coefficients via consecutive hashing
      let coeff_0: field = secret;
      let coeff_1: field = Poseidon2::hash_to_field(coeff_0);
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
      let coeff_13: field = Poseidon2::hash_to_field(coeff_12);
      let coeff_14: field = Poseidon2::hash_to_field(coeff_13);
      let coeff_15: field = Poseidon2::hash_to_field(coeff_14);
      let coeff_16: field = Poseidon2::hash_to_field(coeff_15);
      let coeff_17: field = Poseidon2::hash_to_field(coeff_16);
      let coeff_18: field = Poseidon2::hash_to_field(coeff_17);
      let coeff_19: field = Poseidon2::hash_to_field(coeff_18);
      let coeff_20: field = Poseidon2::hash_to_field(coeff_19);
      let coeff_21: field = Poseidon2::hash_to_field(coeff_20);
      let coeff_22: field = Poseidon2::hash_to_field(coeff_21);
      let coeff_23: field = Poseidon2::hash_to_field(coeff_22);
      let coeff_24: field = Poseidon2::hash_to_field(coeff_23);
      let coeff_25: field = Poseidon2::hash_to_field(coeff_24);
      let coeff_26: field = Poseidon2::hash_to_field(coeff_25);
      let coeff_27: field = Poseidon2::hash_to_field(coeff_26);
      let coeff_28: field = Poseidon2::hash_to_field(coeff_27);
      let coeff_29: field = Poseidon2::hash_to_field(coeff_28);
      let coeff_30: field = Poseidon2::hash_to_field(coeff_29);
      let coeff_31: field = Poseidon2::hash_to_field(coeff_30);

      // represent coeffs as an array
      let coeffs: [field; 32] = [coeff_0, coeff_1, coeff_2, coeff_3, coeff_4, coeff_5, coeff_6, coeff_7, coeff_8, coeff_9, coeff_10, coeff_11, coeff_12, coeff_13, coeff_14, coeff_15, coeff_16, coeff_17, coeff_18, coeff_19, coeff_20, coeff_21, coeff_22, coeff_23, coeff_24, coeff_25, coeff_26, coeff_27, coeff_28, coeff_29, coeff_30, coeff_31];

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
      [43field, horner(coeffs, 43field)],
      [44field, horner(coeffs, 44field)],
      [45field, horner(coeffs, 45field)],
      [46field, horner(coeffs, 46field)],
      [47field, horner(coeffs, 47field)],
      [48field, horner(coeffs, 48field)],
      [49field, horner(coeffs, 49field)],
      [50field, horner(coeffs, 50field)],
      [51field, horner(coeffs, 51field)],
      [52field, horner(coeffs, 52field)],
      [53field, horner(coeffs, 53field)],
      [54field, horner(coeffs, 54field)],
      [55field, horner(coeffs, 55field)],
      [56field, horner(coeffs, 56field)],
      [57field, horner(coeffs, 57field)],
      [58field, horner(coeffs, 58field)],
      [59field, horner(coeffs, 59field)],
      [60field, horner(coeffs, 60field)],
      [61field, horner(coeffs, 61field)],
      [62field, horner(coeffs, 62field)],
      [63field, horner(coeffs, 63field)],
      [64field, horner(coeffs, 64field)]
      ],
     [
      [65field, horner(coeffs, 65field)],
      [66field, horner(coeffs, 66field)],
      [67field, horner(coeffs, 67field)],
      [68field, horner(coeffs, 68field)],
      [69field, horner(coeffs, 69field)],
      [70field, horner(coeffs, 70field)],
      [71field, horner(coeffs, 71field)],
      [72field, horner(coeffs, 72field)],
      [73field, horner(coeffs, 73field)],
      [74field, horner(coeffs, 74field)],
      [75field, horner(coeffs, 75field)],
      [76field, horner(coeffs, 76field)],
      [77field, horner(coeffs, 77field)],
      [78field, horner(coeffs, 78field)],
      [79field, horner(coeffs, 79field)],
      [80field, horner(coeffs, 80field)],
      [81field, horner(coeffs, 81field)],
      [82field, horner(coeffs, 82field)],
      [83field, horner(coeffs, 83field)],
      [84field, horner(coeffs, 84field)],
      [85field, horner(coeffs, 85field)],
      [86field, horner(coeffs, 86field)],
      [87field, horner(coeffs, 87field)],
      [88field, horner(coeffs, 88field)],
      [89field, horner(coeffs, 89field)],
      [90field, horner(coeffs, 90field)],
      [91field, horner(coeffs, 91field)],
      [92field, horner(coeffs, 92field)],
      [93field, horner(coeffs, 93field)],
      [94field, horner(coeffs, 94field)],
      [95field, horner(coeffs, 95field)],
      [96field, horner(coeffs, 96field)]
      ]

      ];

    }
  
  }
