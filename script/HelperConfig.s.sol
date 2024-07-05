// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    uint256 private constant SEPOLIA_CHAINID = 11155111;
    uint256 private constant MAINNET_CHAINID = 1;

    uint8 private constant DECIMALS = 8;
    int256 private constant INITIAL_ANSWER = 2000e8;

    mapping(uint256 => NetworkConfig) private networkConfigs;

    constructor() {
        if (block.chainid == SEPOLIA_CHAINID) {
            createSepoliaEthConfig();
        } else if (block.chainid == MAINNET_CHAINID) {
            createMainnetEthConfig();
        } else {
            createAnvilEthConfig();
        }
    }

    function createSepoliaEthConfig() private {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});

        networkConfigs[SEPOLIA_CHAINID] = sepoliaConfig;
    }

    function createMainnetEthConfig() private {
        NetworkConfig memory mainnetConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});

        networkConfigs[MAINNET_CHAINID] = mainnetConfig;
    }

    function createAnvilEthConfig() private {
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        networkConfigs[block.chainid] = anvilConfig;
    }

    function activeNetworkConfig() public view returns (NetworkConfig memory) {
        return networkConfigs[block.chainid];
    }
}
