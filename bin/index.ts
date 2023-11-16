import { generateCircuit } from "./generate";

if (import.meta.main) {
  /** Leo looks for main.leo to run the code. */
  const CODE_TARGET = "./src/main.leo";

  /** Leo looks for inputs/shamir.in to parse inputs, especially for `recover`. */
  const IN_TARGET = "./inputs/shamir.in";

  let N = 10; // number of evaluation points
  let K = 3; // degree of polynomial

  if (Bun.argv.length > 2)
    try {
      N = parseInt(Bun.argv[2]);
      if (N < 2) throw new Error(`You must split your secret to at least N=2 pieces`);
      K = N; // If user provided N but no K, fallback to K = N
    } catch (e) {
      console.error(`Please provide a valid integer for N. Error: ${e}`);
    }
  if (Bun.argv.length > 3)
    try {
      K = parseInt(Bun.argv[3]);
      if (K > N) throw new Error(`K cannot be > N, but you provided N=${N} and K=${K}`);
    } catch (e) {
      console.error(`Please provide a valid integer for K. Error: ${e}`);
    }

  console.log(`Generating (k: ${K}, n: ${N}) Shamir Secret Share for Aleo.`);
  const code = generateCircuit(K, N);

  // output to main
  await Bun.write(CODE_TARGET, code);

  // also prepare input file
  await Bun.write(
    IN_TARGET,
    `[recover]
evals: [[field; 2]; ${K}] = [

];
`,
  );

  console.log("Created code at:", CODE_TARGET);
}
