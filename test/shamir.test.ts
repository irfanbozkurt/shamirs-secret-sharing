import { describe, expect, it } from "bun:test";
import { generateCircuit } from "../bin/generate";
import { createInput, parseOutput, randomIndices } from "../bin/utils";

const testCases: { K: number; N: number }[] = [
  { K: 3, N: 8 },
  // { K: 3, N: 5 },
  // { K: 2, N: 3 },
];

testCases.map(({ K, N }) =>
  describe(`shamir secret sharing (k=${K}, n=${N})`, () => {
    let secret: bigint;
    let evals: [bigint, bigint][] = [];

    it("should generate code", async () => {
      secret = BigInt(Math.round(Math.random() * 1_000_000_000));

      const code = generateCircuit(K, N);

      // `leo run split` looks for main.leo so we have to do this
      await Bun.write("./src/main.leo", code);
    });

    it("should split a secret", async () => {
      const proc = Bun.spawn(["leo", "run", "split", `${secret}field`]);
      const output = await new Response(proc.stdout).text();

      evals = parseOutput(N, output);
    });

    it("should recover the secret from `k` random points", async () => {
      // create unique random points
      const randomEvals = randomIndices(K, N).map((p) => evals[p]);
      const input = createInput(randomEvals);

      // `leo run recover` reads input from here
      await Bun.write("./inputs/shamir.in", input);

      const proc = Bun.spawn(["leo", "run", "recover"]);
      const output = await new Response(proc.stdout).text();

      const parsedOutput = output
        .slice(output.lastIndexOf("•") + 1, output.lastIndexOf("Leo ✅ Finished"))
        .replaceAll("field", "")
        .trim();

      const recovered = BigInt(parsedOutput);

      expect(recovered).toBe(secret);
    });
  }),
);
