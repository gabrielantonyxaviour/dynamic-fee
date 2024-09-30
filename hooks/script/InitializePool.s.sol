// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "forge-std/Script.sol";
// import {IHooks} from "pancake-v4-core/src/interfaces/IHooks.sol";
// import {ICLPoolManager} from "pancake-v4-core/src/pool-cl/interfaces/ICLPoolManager.sol";
// import {Currency} from "pancake-v4-core/src/types/Currency.sol";
// import {Constants} from "pancake-v4-core/test/pool-cl/helpers/Constants.sol";
// import {Deployers} from "pancake-v4-core/test/pool-cl/helpers/Deployers.sol";
// import {PoolKey} from "pancake-v4-core/src/types/PoolKey.sol";
// import {PoolId} from "pancake-v4-core/src/types/PoolId.sol";
// import "../src/pool-cl/CLCounterHook.sol";
// import {CLTestUtils} from "../test/pool-cl/utils/CLTestUtils.sol";

// contract InitializePool is Script, CLTestUtils {
//     function run() external override {
//         // Begin broadcasting (enables sending transactions)
//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//         vm.startBroadcast(deployerPrivateKey);

//         address poolManager=0x6F9302eE8760c764d775B1550C65468Ec4C25Dfc; // Replace with the actual pool manager address
//         // address hook=0x212ac7edaa4b96361204299B23Fa3648583F2451;
//         // address deployer=0x3Ed76fF3c9b575B7Add4c93C16D6C134d731333d;

//         uint24 fee= 0x800000; // Dynamic fee
//         // Deploy Mock Currencies
//         (Currency currency0, Currency currency1) = deployContractsWithTokens();
//         CLCounterHook hook = new CLCounterHook(ICLPoolManager(poolManager));

//         // create the pool key
//         PoolKey memory key = PoolKey({
//             currency0: currency0,
//             currency1: currency1,
//             hooks: hook,
//             poolManager: poolManager,
//             fee: uint24(0x800000), // 0.3% fee
//             // tickSpacing: 10
//             parameters: bytes32(uint256(hook.getHooksRegistrationBitmap())).setTickSpacing(10)
//         });

//         // initialize pool at 1:1 price point (assume stablecoin pair)
//         poolManager.initialize(key, Constants.SQRT_RATIO_1_1, new bytes(0));
//         // End broadcasting
//         vm.stopBroadcast();
//     }
// }
