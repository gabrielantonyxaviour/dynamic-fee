// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./lib/BrevisApp.sol";

// Accept both ZK- and OP-attested results.
contract AccountAge is BrevisApp, Ownable {
    event AccountAgeAttested(address account, uint64 blockNum);

    bytes32 public vkHash;

    constructor(address _brevisRequest) BrevisApp(_brevisRequest) Ownable(msg.sender) {}

    // BrevisRequest contract will trigger callback once ZK proof is received.
    function handleProofResult(bytes32 _vkHash, bytes calldata _circuitOutput) internal override {
        require(vkHash == _vkHash, "invalid vk");
        (address txFrom, uint64 blockNum) = decodeOutput(_circuitOutput);
        emit AccountAgeAttested(txFrom, blockNum);
    }

    function handleOpProofResult(bytes32 _vkHash, bytes calldata _circuitOutput) internal override {
        handleProofResult(_vkHash, _circuitOutput);
    }

    function decodeOutput(bytes calldata o) internal pure returns (address, uint64) {
        address txFrom = address(bytes20(o[0:20])); // txFrom was output as an address
        uint64 blockNum = uint64(bytes8(o[20:28])); // blockNum was output as a uint64 (8 bytes)
        return (txFrom, blockNum);
    }

    function setVkHash(bytes32 _vkHash) external onlyOwner {
        vkHash = _vkHash;
    }

    function setBrevisOpConfig(uint64 _challengeWindow, uint8 _sigOption) external onlyOwner {
        brevisOpConfig = BrevisOpConfig(_challengeWindow, _sigOption);
    }
}
