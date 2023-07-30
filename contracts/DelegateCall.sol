// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    // Types of below have to be the same and in same order as in contract B. Otherwise It will convert type and you will get type from contract A
    uint256 public firstVariable; // It is taking 1st slot from storage and assign corresponded value from contract B, so "num"
    address public secondVariable; // It is taking 2nd slot from storage and assign corresponded value from contract B, so "sender"
    uint256 public thirdVariable; // It is taking 3rd slot from storage and assign corresponded value from contract B, so "value"

    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified.
        (bool success /* bytes memory data */, ) = _contract.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        if (success) {}
    }
}

/// @dev Try below in Remix

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public returns (string memory) {
        s_someAddress = someAddress;
        s_amount = amount;

        string memory message = "Transfer Performed!";
        return message;
    }

    function getSelector() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));

        return selector;
    }

    function getDataToCall(address someAddress, uint256 amount) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getSelector(), someAddress, amount);
    }

    function callFunction(address someAddress, uint56 amount) public returns (bytes memory, bool, string memory) {
        /// @dev returnData will be return of called function, in this case message from transfer
        (bool success, bytes memory returnData) = address(this).call(getDataToCall(someAddress, amount));

        string memory our = string(returnData);
        return (returnData, success, our);
    }

    /// @dev example for call by function signature
    function callFunctionSignature(address someAddress, uint56 amount) public returns (bytes memory, bool, string memory) {
        /// @dev returnData will be return of called function, in this case message from transfer
        (bool success, bytes memory returnData) = address(this).call(abi.encodeWithSignature("transfer(address,uint256)", someAddress, amount));

        string memory our = string(returnData);
        return (returnData, success, our);
    }
}
