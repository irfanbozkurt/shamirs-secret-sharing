# Shamir's Secret Sharing

Shamiroquai allows users to generate Leo code that splits a given secret into <b>k</b> pieces, which recover the original secret when all put back together.

- <b>k</b> is the number of evaluations required to reconstruct the secret.
- <b>n</b> is the number of evaluations you want. Again, <b>k</b> of them will suffice for recovery.

# Considerations

1. Leo does not support variable-sized arrays. To achieve fine-grained functionality, we present TypeScript code that generates SSS as Leo code.
2. We generate code

## Codegen

```sh
bun gen -- <n> <k>
bun gen -- 10 3
```

This will also prepare a <b>inputs/shamir.in</b> file in which user will put the inputs to the <b>recover</b> function (more on this later).

## Splitting the secret

AFTER the codegen phase, run the following command from the root directory to split the secret (Please note that your secret needs to be a [field element](https://developer.aleo.org/advanced/the_aleo_curves/edwards_bls12/)).

```sh
bun split -- <secret>
bun split -- 96024field
```

<br>

<details>
    <summary>See the output</summary>

```
[
  [
    1field,
    247124353110039464027783481657025336652283630264529970142356661250969790763field
  ],
  [
    2field,
    2623338585292326120762717092544346887783856124624707017714168454507210488384field
  ],
  [
    3field,
    7128642696546859970204800832661964653394717483080531142715435379768722188887field
  ],
  [
    4field,
    5318574937445270588105209763228332102108968370477938517210923981118095653231field
  ],
  [
    5field,
    5637597057415928398712768823024995765302508121970992969135867714472740120457field
  ],
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
  ],
  [
    9field,
    2871199079735920295468031538169972968741857763437490067324493600191800301058field
  ],
  [
    10field,
    5391208845639443645362516305336571172955942500254716078461479537655390543653field
  ]
]
```

</details>

<br>

## Recovering the secret

Grab <b>k</b> of the field elements outputted in step-2, and place them into /inputs/shamir.in

For k=3, the file should already look as follows:

```
[recover]
evals: [[field; 2]; 3] = [

];
```

User basically needs to place any 3 elements outputted by step-2 here. A valid input would look as follows:

```
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
```

And you have the secret back.
