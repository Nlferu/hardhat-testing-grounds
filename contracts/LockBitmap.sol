// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract BitmapLocker {
    uint256 private lockedTokensBitmap;

    function lockToken(uint256 tokenId) external {
        require(tokenId < 256, "Token ID out of range");
        lockedTokensBitmap |= (1 << tokenId); // Set the bit for the tokenId
    }

    function unlockToken(uint256 tokenId) external {
        require(tokenId < 256, "Token ID out of range");
        lockedTokensBitmap &= ~(1 << tokenId); // Clear the bit for the tokenId
    }

    function isTokenLocked(uint256 tokenId) external view returns (bool) {
        require(tokenId < 256, "Token ID out of range");
        return (lockedTokensBitmap & (1 << tokenId)) != 0;
    }
}
