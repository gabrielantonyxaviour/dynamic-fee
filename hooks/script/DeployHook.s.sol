// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/pool-cl/CLCounterHook.sol";
import {ICLPoolManager} from "pancake-v4-core/src/pool-cl/interfaces/ICLPoolManager.sol";

contract DeployHook is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the contract
        ICLPoolManager CLPoolManager=ICLPoolManager(0x6F9302eE8760c764d775B1550C65468Ec4C25Dfc);
        CLCounterHook counterHook = new CLCounterHook(CLPoolManager);

        vm.stopBroadcast();
    }
}
