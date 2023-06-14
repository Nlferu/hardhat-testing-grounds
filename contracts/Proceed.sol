// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

error NotEnoughETH();
error TransferFailed(address recipient, uint256 amount);

contract Proceed {
    event PendingBidsWithdrawal(uint256 indexed amount, address indexed recipient, bool indexed success);

    uint256 minFund;

    mapping(address => uint256) private pendingReturns;

    constructor(uint256 _minFund) {
        minFund = _minFund;
    }

    function fundContract() external payable {
        if (msg.value < minFund) revert NotEnoughETH();
        pendingReturns[msg.sender] += msg.value;
    }

    function withdrawPending(address recipient) external payable {
        uint256 amount = pendingReturns[msg.sender];

        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
        } else {
            revert NotEnoughETH();
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            pendingReturns[msg.sender] = amount;
            revert TransferFailed(msg.sender, amount);
        }

        emit PendingBidsWithdrawal(amount, recipient, success);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
