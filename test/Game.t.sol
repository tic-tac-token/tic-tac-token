// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract GameTest is Test {
    Game public game;

    function setUp() public {
        game = new Game();
    }

    function test_first_space_is_empty() public {
        bytes1 space = game.board(0);
        assertEq(space, "");
    }

    function test_full_board_is_empty() public {
        for (uint256 i; i < 9; ++i) {
            bytes1 space = game.board(i);
            assertEq(space, "");
        }
    }

    function test_mark_first_space_with_x() public {
        game.markSpace(0, "X");
        assertEq(game.board(0), "X");
    }

    function test_mark_second_space_with_o() public {
        game.markSpace(1, "O");
        bytes1 space = game.board(1);
        assertEq(space, "O");
    }

    function test_reverts_if_marker_is_invalid() public {
        vm.expectRevert("Invalid marker");
        game.markSpace(1, "Z");
    }

    function test_mark_invalid_space() public {
        vm.expectRevert("Invalid space");
        game.markSpace(9, "X");
    }

    function test_mark_already_marked_space_reverts() public {
        game.markSpace(0, "X");
        vm.expectRevert("Already marked");
        game.markSpace(0, "O");
    }
}
