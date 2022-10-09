// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Game {
    bytes1[9] public board;
    address public playerX;
    address public playerO;

    uint256 public turns;

    constructor(address _playerX, address _playerO) {
        playerX = _playerX;
        playerO = _playerO;
    }

    modifier onlyPlayer() {
        require(msg.sender == playerX || msg.sender == playerO, "Unauthorized");
        _;
    }

    function markSpace(uint256 space) public onlyPlayer {
        require(space < 9, "Invalid space");
        require(board[space] == "", "Already marked");
        require(winner() == "", "Someone has won");
        require(msg.sender == _currentTurn(), "Not your turn");

        board[space] = _currentMarker();
        ++turns;
    }

    function _currentTurn() internal  returns (address) {
        return (turns % 2 == 0) ? playerX : playerO;
    }

    function _currentMarker() internal returns (bytes1) {
        return (_currentTurn() == playerX) ? bytes1("X") : bytes1("O");
    }

    // 0 | 1 | 2
    // 3 | 4 | 5
    // 6 | 7 | 8
    function winner() public view returns (bytes1) {
        uint8[3][8] memory wins = [
            [0, 1, 2], // row 1
            [3, 4, 5], // row 2
            [6, 7, 8], // row 3
            [0, 3, 6], // col 1
            [1, 4, 7], // col 2
            [2, 5, 8], // col 3
            [0, 4, 8], // diag 1 t2b
            [6, 4, 2] // diag 2 b2t
        ];
        for (uint256 i; i < wins.length; ++i) {
            uint8[3] memory win = wins[i];
            uint8 idx1 = win[0];
            uint8 idx2 = win[1];
            uint8 idx3 = win[2];
            if (board[idx1] == board[idx2] && board[idx2] == board[idx3]) {
                return board[idx1];
            }
        }
        return "";
    }
}
