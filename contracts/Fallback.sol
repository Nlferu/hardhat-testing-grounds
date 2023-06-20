// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Fallback {
    uint256 public result;

    /// @dev Whenever we send ETH or make transaction to this contract and there is no data associated with this transaction (In Remix it's empty CALLDATA field)
    // below receive() will get triggered
    receive() external payable {
        result = 1;
    }

    /// @dev It is the same as receive(), but it can take data (In Remix it's empty CALLDATA field)
    fallback() external payable {
        result = 2;
    }

    /** Explainer 
      
        Ether is sent to contract
            is msg.data empty?
                 /  \
                yes  no
                /     \
            receive()?  fallback()
            /   \
          yes    no
          /        \
        receive()  fallback()

    */
}
