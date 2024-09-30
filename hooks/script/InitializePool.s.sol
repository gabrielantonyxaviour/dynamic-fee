// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ICLPoolManager} from "pancake-v4-core/src/pool-cl/interfaces/ICLPoolManager.sol";
import {Constants} from "pancake-v4-core/test/pool-cl/helpers/Constants.sol";
import "../src/pool-cl/CLCounterHook.sol";


import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {CLPoolManager} from "pancake-v4-core/src/pool-cl/CLPoolManager.sol";
import {Vault} from "pancake-v4-core/src/Vault.sol";
import {Currency} from "pancake-v4-core/src/types/Currency.sol";
import {SortTokens} from "pancake-v4-core/test/helpers/SortTokens.sol";
import {PoolKey} from "pancake-v4-core/src/types/PoolKey.sol";
import {CLPositionManager} from "pancake-v4-periphery/src/pool-cl/CLPositionManager.sol";
import {ICLPositionManager} from "pancake-v4-periphery/src/pool-cl/interfaces/ICLPositionManager.sol";
import {ICLRouterBase} from "pancake-v4-periphery/src/pool-cl/interfaces/ICLRouterBase.sol";
import {PositionConfig} from "pancake-v4-periphery/src/pool-cl/libraries/PositionConfig.sol";
import {Planner, Plan} from "pancake-v4-periphery/src/libraries/Planner.sol";
import {Actions} from "pancake-v4-periphery/src/libraries/Actions.sol";
import {DeployPermit2} from "permit2/test/utils/DeployPermit2.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";
import {UniversalRouter, RouterParameters} from "pancake-v4-universal-router/src/UniversalRouter.sol";
import {Commands} from "pancake-v4-universal-router/src/libraries/Commands.sol";
import {ActionConstants} from "pancake-v4-periphery/src/libraries/ActionConstants.sol";
import {LiquidityAmounts} from "pancake-v4-periphery/src/pool-cl/libraries/LiquidityAmounts.sol";
import {TickMath} from "pancake-v4-core/src/pool-cl/libraries/TickMath.sol";
import {PoolId, PoolIdLibrary} from "pancake-v4-core/src/types/PoolId.sol";
import {CLPoolParametersHelper} from "pancake-v4-core/src/pool-cl/libraries/CLPoolParametersHelper.sol";

contract InitializePool is Script {
    using CLPoolParametersHelper for bytes32;

       function deployContractsWithTokens() internal returns (Currency, Currency) {

        MockERC20 token0 = new MockERC20("token0", "T0", 18);
        MockERC20 token1 = new MockERC20("token1", "T1", 18);

        // approve permit2 contract to transfer our funds
        // token0.approve(address(permit2), type(uint256).max);
        // token1.approve(address(permit2), type(uint256).max);

        // permit2.approve(address(token0), address(positionManager), type(uint160).max, type(uint48).max);
        // permit2.approve(address(token1), address(positionManager), type(uint160).max, type(uint48).max);

        // permit2.approve(address(token0), address(universalRouter), type(uint160).max, type(uint48).max);
        // permit2.approve(address(token1), address(universalRouter), type(uint160).max, type(uint48).max);

        return SortTokens.sort(token0, token1);
    }
    function run() external {
        // Begin broadcasting (enables sending transactions)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ICLPoolManager poolManager=ICLPoolManager(0x6F9302eE8760c764d775B1550C65468Ec4C25Dfc); // Replace with the actual pool manager address
        CLCounterHook hook=CLCounterHook(0x212ac7edaa4b96361204299B23Fa3648583F2451);

        uint24 fee= 0x800000; // Dynamic fee
        // Deploy Mock Currencies
        (Currency currency0, Currency currency1) = deployContractsWithTokens();

        PoolKey memory key = PoolKey({
            currency0: currency0,
            currency1: currency1,
            hooks: hook,
            poolManager: poolManager,
            fee: fee, 
            parameters: bytes32(uint256(hook.getHooksRegistrationBitmap())).setTickSpacing(10)
        });
        poolManager.initialize(key, Constants.SQRT_RATIO_1_1, new bytes(0));
        // End broadcasting
        vm.stopBroadcast();
    }
}
