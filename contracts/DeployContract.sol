// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract DeployContract {
    address public owner;
    uint256 public x;

    constructor(uint256 _x) {
        owner = msg.sender;
        x = _x;
    }
}
