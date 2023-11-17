/**
 * Finds the number of bytes w.r.t Aleo data-types to fit the index number.
 * @param x number
 * @returns bits of 8 to fit the number
 */
export function getBitSize(x: number): 8 | 16 | 32 | 64 | 128 {
  const b = Math.ceil(Math.log2(x));
  for (const b8 of [8, 16, 32, 64, 128] as const) {
    if (b <= b8) {
      return b8;
    }
  }
  throw new Error("cant have 128-bit index");
}

/**
 * Returns an array of unique random indices without repetition.
 * @param k number of random indices
 * @param n array length
 */
export function randomIndices(k: number, n: number) {
  const values: Record<number, boolean> = {};

  while (k !== 0) {
    const r = Math.floor(Math.random() * n);
    if (!values[r]) {
      values[r] = true;
      k--;
    }
  }

  return Object.keys(values).map((s) => parseInt(s));
}

/**
 * Parses a Leo output (especifically that of the `split` function) and returns
 * the given array of evaluations.
 *
 * @param n number of evaluations
 * @param output stdout from the process
 * @returns an array of evaluations
 */
export function parseOutput(n: number, output: string): [bigint, bigint][] {
  output = output
    .slice(output.indexOf("["), output.lastIndexOf("]") + 1)
    .replaceAll("field", "")
    .replaceAll(",", "");

  const lines = output
    .split("\n")
    .map((line) => line.trim())
    .filter((l) => l !== "[" && l !== "]");

  return Array.from({ length: n }, (_, i) => [BigInt(lines[i * 2]), BigInt(lines[i * 2 + 1])] as [bigint, bigint]);
}

/**
 * Creates an input file to be used with `recover` function for the given evaluations.
 * @param evals evaluation points
 * @returns input file content
 */
export function createInput(evals: [bigint, bigint][]): string {
  const evalStrs = evals.map(
    (e) => `[
    ${e[0].toString()}field,
    ${e[1].toString()}field
  ]`,
  );

  return `[recover]
evals: [[field; 2]; ${evals.length}] = [
  ${evalStrs.join(",\n  ")}
];
`;
}
