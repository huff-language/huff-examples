# huff-examples • [![ci](https://github.com/huff-language/huff-examples/actions/workflows/ci.yaml/badge.svg)](https://github.com/huff-language/huff-examples/actions/workflows/ci.yaml) ![license](https://img.shields.io/github/license/huff-language/huff-examples.svg) ![solidity](https://img.shields.io/badge/solidity-^0.8.15-lightgrey)

A Collection of Verbosely Document Huff Contracts.


### Usage

Make sure you've installed the Huff Compiler as outlined in the [Huff Docs](https://docs.huff.sh/get-started/installing/).

TL;DR: `curl -L get.huff.sh | bash && huffup`

To verify your installation, run `huffc --help`. This should print a list of available commands for the huff compiler cli.


### Steps

This is how to create the contract bytecode to output _Hello, World!_ in Huff.

1. Create a file called `hello-world.huff` and enter the following content:

    ```javascript
    #define macro MAIN() = takes (0) returns (0) {
        0x48656c6c6f2c20776f726c6421 0x00 mstore // Store "Hello, World!" in memory.
        0x1a 0x00 return // Return 26 bytes starting from memory pointer 0.
    }
    ```

2. Use `huffc` to compile the contract and output bytecode:

    ```shell
    huffc hello-world.huff --bytecode
    ```

    This will output something like:

    ```plaintext
    6100168061000d6000396000f36c48656c6c6f2c20776f726c6421600052601a6000f3
    ```

3. To test contracts, Huff Language contributors created [foundry-huff](https://github.com/huff-language/foundry-huff), a foundry library written in solidity, to allow you to test your Huff contracts in solidity. Simply install dependencies and run tests with:

    ```shell
    forge install
    forge test
    ```

    _NOTE: This requires [Foundry](https://foundry.sh) to be installed. You can install it with `curl -L https://foundry.paradigm.xyz | bash`._

## More help

Run `huffc --help` to view a full list of arguments.
