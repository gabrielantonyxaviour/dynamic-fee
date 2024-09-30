// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/LocalDeployers.sol";

contract Deplou is Script {
    function run() external {
        vm.startBroadcast();

        LocalDeployers deployers=new LocalDeployers();

        vm.stopBroadcast();
    }
}