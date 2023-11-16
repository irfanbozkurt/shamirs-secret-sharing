# Shamir's Secret Sharing

We allow users to generate Leo code that splits a given secret into <b>k</b> pieces, which recover the original secret when all put back together.

- <b>k</b> is the number of evaluations required to reconstruct the secret. Maximum value it can take is 32 (bounded by Leo's array size).
- <b>n</b> is the number of evaluations you want. Again, <b>k</b> of them will suffice for recovery.

# Considerations

1. Leo does not support variable-sized arrays. To achieve fine-grained functionality, we present TypeScript code that generates SSS as Leo code.
2. We support secret splitting up to 32 pieces (k <= 32), but you can get as many evaluations (of your secret polynomial) as you want. For example, you can get 550 evaluations of your secret polynomial, out of which <b>k</b> of them will suffice for recovery.

# How to Use

## Codegen

```sh
bun gen -- <n> <k>
bun gen -- 10 3
```

This will output a <b>outputs/main.leo</b> that contains all required Leo code to split a given secret and to recover it back, following given parameters.

This will also prepare a <b>inputs/shamir.in</b> file in which user will put the inputs to the <b>recover</b> function (more on this later).

## Splitting the secret

AFTER the codegen phase, run the following command from the root directory to split the secret (Please note that your secret needs to be a [field element](https://developer.aleo.org/advanced/the_aleo_curves/edwards_bls12/)).

```sh
bun split -- <secret>
bun split -- 96024field
```

<br>

<details>
    <summary>See example output for n=10</summary>

```
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
