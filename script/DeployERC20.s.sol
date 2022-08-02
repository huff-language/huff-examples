// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import { Script } from "forge-std/Script.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

contract DeployERC20Script is Script {
    function run() public returns (address deployed) {
        deployed = HuffDeployer.deploy("ERC20/ERC20");
    }
}
