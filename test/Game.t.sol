// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Game.sol";

contract GameTest is Test {
    Game public game;

    address playerX = makeAddr("player x");
    address playerO = makeAddr("player o");

    address eve = makeAddr("eve");

    function setUp() public {
        game = new Game(playerX, playerO);
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
        vm.prank(playerX);
        game.markSpace(0);
        assertEq(game.board(0), "X");
    }

    function test_mark_second_space_with_o() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(1);
        bytes1 space = game.board(1);
        assertEq(space, "O");
    }

    function test_mark_invalid_space() public {
        vm.expectRevert("Invalid space");
        vm.prank(playerX);
        game.markSpace(9);
    }

    function test_mark_already_marked_space_reverts() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.expectRevert("Already marked");
        vm.prank(playerO);
        game.markSpace(0);
    }

    function test_check_for_winner_row() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(3);

        vm.prank(playerX);
        game.markSpace(1);

        vm.prank(playerO);
        game.markSpace(4);

        vm.prank(playerX);
        game.markSpace(2);

        assertEq(game.winner(), "X");
    }

    function test_check_for_winner_col() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(1);

        vm.prank(playerX);
        game.markSpace(3);

        vm.prank(playerO);
        game.markSpace(2);

        vm.prank(playerX);
        game.markSpace(6);

        assertEq(game.winner(), "X");
    }

    function test_check_for_winner_diag1() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(1);

        vm.prank(playerX);
        game.markSpace(4);

        vm.prank(playerO);
        game.markSpace(2);

        vm.prank(playerX);
        game.markSpace(8);

        assertEq(game.winner(), "X");
    }

    function test_check_for_winner_diag2() public {
        vm.prank(playerX);
        game.markSpace(6);

        vm.prank(playerO);
        game.markSpace(0);

        vm.prank(playerX);
        game.markSpace(4);

        vm.prank(playerO);
        game.markSpace(1);

        vm.prank(playerX);
        game.markSpace(2);

        assertEq(game.winner(), "X");
    }

    function test_cannot_mark_space_once_game_is_over() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(3);

        vm.prank(playerX);
        game.markSpace(1);

        vm.prank(playerO);
        game.markSpace(4);

        vm.prank(playerX);
        game.markSpace(2);

        vm.prank(playerX);
        vm.expectRevert("Someone has won");
        game.markSpace(6);
    }

    function test_game_has_player_x_address() public {
        assertEq(game.playerX(), playerX);
    }

    function test_game_has_player_o_address() public {
        assertEq(game.playerO(), playerO);
    }

    function test_only_authorized_players_can_mark_squares() public {
        vm.expectRevert("Unauthorized");
        vm.prank(eve);
        game.markSpace(1);
    }

    function test_players_must_alternate_turns() public {
        vm.prank(playerX);
        game.markSpace(0);

        vm.prank(playerO);
        game.markSpace(1);

        vm.prank(playerO);
        vm.expectRevert("Not your turn");
        game.markSpace(2);
    }
}
