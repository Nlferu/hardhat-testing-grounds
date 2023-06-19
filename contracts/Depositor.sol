// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error YouWantToSendTooMuch();

contract Depositor {
    function getETH(uint256 minValue) external payable {
        // Getting 1 ETH
        require(msg.value >= minValue * 1e18);
    }

    function sendETH(address payable _receiver, uint256 _amount) external payable returns (bytes memory) {
        if (_amount > address(this).balance) revert YouWantToSendTooMuch();
        // Below amount will be taken from wallet assigned to {value} as _amount is from contract this amount will be taken from contract
        // In case we would use "msg.value" instead of "_amount" this would be taken from msg.caller wallet balance

        // "getETH(uint256)" this will attempt to call such function on receiver side
        /// @dev To call another function from _receiver use below
        // (bool sent, bytes memory data) = _receiver.call{value: _amount * 1e18}(abi.encodeWithSignature("getETH(uint256)", _amount));

        (bool sent, bytes memory data) = _receiver.call{value: _amount * 1e18}("");
        require(sent, "Transfer Failed!");
        return data;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
