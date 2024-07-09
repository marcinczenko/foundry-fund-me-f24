# foundry-fund-me-f24

This is the repo from online training [foundry-fund-me](https://github.com/Cyfrin/foundry-full-course-cu?tab=readme-ov-file#section-7-foundry-fund-me).

After being away from active blockchain development for some time, it is a great source to refresh and update on the new developments.

There is no point of exhaustively documenting the repo, as it is sufficiently documented on the training portal, yet, for my own use it is good to include a short recap.

## Foundry Book

The documentation of the foundry environment: https://book.getfoundry.sh.

To install foundry just follow the documentation, or run:

```bash
$ curl -L https://foundry.paradigm.xyz | bash
$ foundryup
```

To work with _zkSynk_ version of foundry, please follow the previous training [foundry-simple-storage](https://github.com/Cyfrin/foundry-full-course-cu?tab=readme-ov-file#section-6-foundry-simple-storage) or directly look in https://github.com/matter-labs/foundry-zksync. When you have everything correctly installed, switching between _vanila_ foundry and zkSync can be done with the commands `foundryup` and `foundryup-zksync` respectively.

Please refer to `Makefile` for some command captured. In particular, it assumes using `cast wallet` to store private keys associated with the accounts used for development. This way we do not need to store private keys anywhere in plaintext. So to add a private key to the cast wallet, just run:

```bash
$ cast wallet import <account-name> --interactive
```

Then you can see in the Makefile that to refer to the private key to be used with transactions, just add:

```bash
--account <account-name> --sender <sender-address> --password-file .password
```

To setup everything, it is good to refer to the `Makefile.example` that contains other helpful commands.

That's it for now...

## Foundry (original generated content)

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
