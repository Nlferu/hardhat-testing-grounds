// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

error Locked();

contract AbstractNotProtected {
    mapping(address => uint) public balances;

    // Update the `balances` mapping to include the new ETH deposited by msg.sender
    function addBalance() public payable {
        balances[msg.sender] += msg.value;
    }

    /** @dev We can protect this by adding "locked" bool */
    //bool locked;

    // Send ETH worth `balances[msg.sender]` back to msg.sender
    function withdraw() public {
        //if (locked) revert Locked();
        //locked = true;

        require(balances[msg.sender] > 0);
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(sent, "Failed to send ether");
        // This code becomes unreachable because the contract's balance is drained
        // before user's balance could have been set to 0
        balances[msg.sender] = 0;

        //locked = false;
    }
}
