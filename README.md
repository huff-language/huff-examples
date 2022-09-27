<img align="right" width="150" height="150" top="100" src="./assets/logo.png">

# huff-examples • [![ci](https://github.com/huff-language/huff-examples/actions/workflows/ci.yaml/badge.svg)](https://github.com/huff-language/huff-examples/actions/workflows/ci.yaml) ![license](https://img.shields.io/github/license/huff-language/huff-examples.svg) ![solidity](https://img.shields.io/badge/solidity-^0.8.15-lightgrey)

Rigorously Tested, Demonstrative Huff Contracts Built with [Huffmate](https://github.com/pentagonxyz/huffmate).

> **Warning**
>
> These contracts are **unaudited** and are not recommended for use in production.
>
> Although contracts have been rigorously reviewed, this is **experimental software** and is provided on an "as is" and "as available" basis.
> We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.


### Pre-requisites

Make sure you've installed the Huff Compiler as outlined in the [Huff Docs](https://docs.huff.sh/get-started/installing/).

TL;DR: `curl -L get.huff.sh | bash && huffup`

To verify your installation, run `huffc --help`. This should print a list of available commands for the huff compiler cli.


### Setup

To simplify the developer experience, Huff Language contributors created [foundry-huff](https://github.com/huff-language/foundry-huff), a foundry library written in solidity. This allows you to test your Huff contracts in solidity and to utilize the [Foundry](https://github.com/foundry-rs/foundry) stack for an ever-growing array of tooling.

To install dependencies, run:

    ```shell
    forge install
    ```

To run tests, run:

    ```shell
    forge test
    ```

You can also update dependencies with `forge update` and format with `forge lint`.

_NOTE: These commands require [Foundry](https://foundry.sh) to be installed. You can install it with `curl -L https://foundry.paradigm.xyz | bash`._


### Contracts

```
src
├─ ERC20 — "Mintable and Burnable ERC20 + EIP-2612 implementation"
└─ ERC721 — "Mintable ERC721 implementation"
```


### Acknowledgements

These contracts were enabled by the following beautiful OSS libraries and tooling:

- [huffmate](https://github.com/pentagonxyz/huffmate)
- [solmate](https://github.com/transmissions11/solmate)
- [foundry](https://github.com/foundry-rs/foundry)
- [foundry-huff](https://github.com/huff-language/foundry-huff)
