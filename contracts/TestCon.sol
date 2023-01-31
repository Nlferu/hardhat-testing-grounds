// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract TestCon {
    uint256 private s_numOne;
    bool private s_initialized; // As default bool is set to "false"

    event EventOne(uint256 indexed storedNumOne, address addressOne);
    event EventTwo(uint256 indexed passedNumTwo, bool initialize);

    constructor() {
        s_numOne = 0;
        s_initialized = true;
    }

    function counterFun(uint256 numTwo) public {
        s_numOne += 1;
        address addrOne = msg.sender;

        numTwo += 2;

        emit EventOne(s_numOne, addrOne);
        emit EventTwo(numTwo, s_initialized);
    }
}
