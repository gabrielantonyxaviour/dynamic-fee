// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PoolKey} from "pancake-v4-core/src/types/PoolKey.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "pancake-v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "pancake-v4-core/src/types/BeforeSwapDelta.sol";
import {PoolId, PoolIdLibrary} from "pancake-v4-core/src/types/PoolId.sol";
import {ICLPoolManager} from "pancake-v4-core/src/pool-cl/interfaces/ICLPoolManager.sol";
import {CLBaseHook} from "./CLBaseHook.sol";
import "../BrevisApp.sol";

contract DynamicFeeHook is CLBaseHook, BrevisApp {
    using PoolIdLibrary for PoolKey;
    bytes32 public vkHash;

    constructor(ICLPoolManager _poolManager, address _brevisRequest) CLBaseHook(_poolManager) BrevisApp(_brevisRequest) {}

    event DynamicFeeUpdated(uint24 fee, uint64 blockNum);

    function getHooksRegistrationBitmap() external pure override returns (uint16) {
        return _hooksRegistrationBitmapFrom(
            Permissions({
                beforeInitialize: false,
                afterInitialize: false,
                beforeAddLiquidity: false,
                afterAddLiquidity: false,
                beforeRemoveLiquidity: false,
                afterRemoveLiquidity: false,
                beforeSwap: true,
                afterSwap: false,
                beforeDonate: false,
                afterDonate: false,
                beforeSwapReturnsDelta: false,
                afterSwapReturnsDelta: false,
                afterAddLiquidityReturnsDelta: false,
                afterRemoveLiquidityReturnsDelta: false
            })
        );
    }

    function beforeSwap(address, PoolKey calldata key, ICLPoolManager.SwapParams calldata, bytes calldata)
        external
        override
        poolManagerOnly
        returns (bytes4, BeforeSwapDelta, uint24)
    {

        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }


    function handleProofResult(bytes32 _vkHash, bytes calldata _circuitOutput) internal override {
        require(vkHash == _vkHash, "invalid vk");
        (uint24 fee, uint64 blockNum) = decodeOutput(_circuitOutput);
        emit DynamicFeeUpdated(fee, blockNum);
    }

    function handleOpProofResult(bytes32 _vkHash, bytes calldata _circuitOutput) internal override {
        handleProofResult(_vkHash, _circuitOutput);
    }

    function decodeOutput(bytes calldata o) internal pure returns (uint24 fee, uint64 blockNum) {
        fee = address(bytes3(o[0:6])); // txFrom was output as an address
        blockNum = uint64(bytes8(o[6:14])); // blockNum was output as a uint64 (8 bytes)
    }

    function setVkHash(bytes32 _vkHash) external onlyOwner {
        vkHash = _vkHash;
    }

    function setBrevisOpConfig(uint64 _challengeWindow, uint8 _sigOption) external onlyOwner {
        brevisOpConfig = BrevisOpConfig(_challengeWindow, _sigOption);
    }
  
}
