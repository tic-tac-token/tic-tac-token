// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Game {
    bytes1[9] public board;

    function markSpace(uint256 space, bytes1 value) public {
        require(space < 9, "Invalid space");
        require(value == "X" || value == "O", "Invalid marker");
        require(board[space] == "", "Already marked");

        board[space] = value;
    }
}
