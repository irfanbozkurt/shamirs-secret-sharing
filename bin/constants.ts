export default {
  /** Leo looks for main.leo to run the code. */
  CODE_TARGET: "./src/main.leo",
  /** Leo looks for inputs/shamir.in to parse inputs, especially for `recover`. */
  IN_TARGET: "./inputs/shamir.in",
} as const;
