# EVM Security Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![ci](https://github.com/TSxo/evm-security-tools/actions/workflows/ci.yaml/badge.svg)](https://github.com/TSxo/evm-security-tools/actions/workflows/ci.yaml)

This repository contains a Dockerfile for building an image pre-installed and
pre-configured with essential tools for Ethereum smart contract security testing.
Primary tools include:

- [Foundry](https://github.com/foundry-rs/foundry): Ethereum application development toolkit
- [Slither](https://github.com/crytic/slither): Static Analyzer for Solidity and Vyper
- [Aderyn](https://github.com/Cyfrin/aderyn): Static Analyzer for Solidity
- [hevm](https://github.com/argotorg/hevm): Symbolic and concrete EVM execution engine
- [Certora CLI](https://docs.certora.com/en/latest/docs/user-guide/index.html): Formal verification
- [solc-select](https://github.com/crytic/solc-select): Manage and switch between Solidity compiler versions
- [Vyper](https://github.com/vyperlang/vyper): Pythonic Smart Contract Language for the EVM

Other tools are also included:

- [n](https://github.com/tj/n): Node version management
- [Node](https://github.com/nodejs/node): Node.js JavaScript runtime
- [Yarn](https://github.com/yarnpkg/yarn): Package manager
- [Python 3](https://www.python.org/): with pip and venv
- [Z3](https://github.com/Z3Prover/z3): Theorem Prover
- [CVC5](https://github.com/cvc5/cvc5): Theorem Prover
- [jq](https://github.com/jqlang/jq): Command-line JSON processor
- [just](https://github.com/casey/just): Command runner
- [cloc](https://github.com/AlDanial/cloc): Count lines of code

## Usage

### Pull the Image

```bash
docker pull ghcr.io/tsxo/evm-security-tools:latest
```

### Run Interactive Container

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/tsxo/evm-security-tools:latest
```

This mounts your current directory to `/workspace` inside the container.

### Example: Analyze a Contract with Slither

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/tsxo/evm-security-tools:latest slither /workspace/src/MyContract.sol
```

### Example: Run Foundry Tests

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/tsxo/evm-security-tools:latest forge test
```

### Example: Symbolic Execution with HEVM

```bash
docker run -it --rm -v $(pwd):/workspace ghcr.io/tsxo/evm-security-tools:latest hevm test
```

## Building from Source

```bash
git clone git@github.com:tsxo/evm-security-tools.git
cd evm-security-tools
docker build -t evm-security-tools .
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Inspired By

Inspired by Trail of Bits' [eth-security-toolbox](https://github.com/trailofbits/eth-security-toolbox).

