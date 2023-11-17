# Shamir's Secret Sharing

We allow users to generate Leo code that splits a given secret into $n$ shares, of which $k$ is sufficient to recover the original secret when all put back together.

- $k$ is the number of evaluations required to reconstruct the secret. Maximum value it can take is 32 (bounded by Leo's array size).
- $n$ is the number of evaluations you want. Again, $k$ of them will suffice for recovery.

## Considerations

1. Leo does not support variable-sized arrays. To achieve fine-grained functionality, we present TypeScript code that generates SSS as Leo code for given $(k, n)$ parameters.
2. We support secret splitting up to 32 pieces $(k \leq 32)$, but you can get as many evaluations (of your secret polynomial) as you want, up to 1024 points. Out of these, $k$ of them will suffice for recovery.

## How to Use

Make sure you have an `.env` file ready for Aleo. It should look like the following:

```sh
NETWORK=testnet3 # or another network of your choice
PRIVATE_KEY=your-private-key # you can generate one with `leo account new`
```

You must first generate the contract for $(k, n)$ parameters of your choice. Then, you can either use `leo run` or our wrappers within `package.json` to split a share, or recover a secret from evaluations. We describe each step within this section. We are using [Bun](https://bun.sh) runtime, which can be installed via:

```sh
curl -fsSL https://bun.sh/install | bash
```

### Generating the Aleo contract

```sh
# bun gen <n> <k>
bun gen 10 3
```

This will output a `outputs/main.leo` that contains all required Leo code to split a given secret and to recover it back, following given parameters. This will also prepare a `inputs/shamir.in` file in which user will put the inputs for the `recover` function (more on this later).

### Splitting the secret

After the codegen phase, run the following command from the root directory to split the secret.

> [!WARNING]  
> Your secret needs to be a [field element](https://developer.aleo.org/advanced/the_aleo_curves/edwards_bls12/).

```sh
# bun split <secret>
bun split 96024field

# or with leo
leo run split 96024field
```

<br>

<details>
    <summary>See example output for <code>n=10</code></summary>

```c
[
  [
    [
      1field,
      5706202619594540077989992285094960082181821933679081517586770005249329693829field
    ],
    [
      2field,
      2967943489760709731731159631408373632987744532204099207238306554581250148197field
    ],
    [
      3field,
      229684359926879385472326977721787183793667130729116896889843103913170602565field
    ],
    [
      4field,
      5935886979521419463462319262816747265975489064408198414476613109162500295974field
    ],
    [
      5field,
      3197627849687589117203486609130160816781411662933216104128149658494420750342field
    ],
    [
      6field,
      459368719853758770944653955443574367587334261458233793779686207826341204710field
    ],
    [
      7field,
      6165571339448298848934646240538534449769156195137315311366456213075670898119field
    ],
    [
      8field,
      3427312209614468502675813586851948000575078793662333001017992762407591352487field
    ],
    [
      9field,
      689053079780638156416980933165361551381001392187350690669529311739511806855field
    ],
    [
      10field,
      6395255699375178234406973218260321633562823325866432208256299316988841500264field
    ]
  ]
]
```

</details>

<br>

### Recovering the secret

Grab $k$ of the field elements outputted in step-2, and place them into `/inputs/shamir.in` file. For $k=3$, the file should already look as follows:

```js
[recover]
evals: [[field; 2]; 3] = [
  /* your inputs shall be pasted here */
];
```

You basically need to place any $k=3$ elements outputted by step-2 here. A valid input would look as follows:

```js
[recover]
evals: [[field; 2]; 3] = [
  [
    6field,
    8085709056458833402027478012051955642975336737559694498490266579832655590565field
  ],
  [
    7field,
    4218449185145615173800512391527665203751554882089979277338887121280432824514field
  ],
  [
    8field,
    2480279192904644138280696900233670979007061890715911133616962794733481061345field
  ]
];
```

After placing this input, you can call the recover algorithm as follows:

```sh
bun recover

# or with leo
leo run recover
```

And you have the secret back.

## Testing

We have written [small tests](https://github.com/irfanbozkurt/shamirs-secret-sharing/blob/main/test/shamir.test.ts) that runs several cases of $(k, n)$ where a random secret is splitted and then recovered again. To run them:

```sh
bun run test
```

Note that this is not `bun test`, but instead calls the `test` script within `package.json` which has some parameters passed into Bun.
