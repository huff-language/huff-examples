// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { Test } from "forge-std/Test.sol";
import { HuffDeployer } from "foundry-huff/HuffDeployer.sol";

import { NonERC721Recipient } from "../utils/NonERC721Recipient.sol";
import { ERC721Recipient } from "../utils/ERC721Recipient.sol";
import { RevertingERC721Recipient } from "../utils/RevertingERC721Recipient.sol";
import { WrongReturnDataERC721Recipient } from "../utils/WrongReturnDataERC721Recipient.sol";

interface IERC721 {
	event Approval(address, address, uint256);
	event ApprovalForAll(address, address, bool);
	event Transfer(address, address, uint256);
	function approve(address, uint256) external;
	function balanceOf(address) external view returns (uint256);
	function getApproved(uint256) external view returns (address);
	function isApprovedForAll(address, address) external view returns (bool);
	function mint(address, uint256) external;
	function name() external returns (string memory);
	function ownerOf(uint256) external view returns (address);
	function setApprovalForAll(address, bool) external;
	function symbol() external returns (string memory);
	function tokenURI(uint256) external returns (string memory);
	function transfer(address, uint256) external;
	function transferFrom(address, address, uint256) external;
}

contract ERC721Test is Test {
    IERC721 token;

    /// @notice Set up the testing suite
    function setUp() public {
        token = IERC721(HuffDeployer.deploy("ERC721/ERC721"));
    }

    // function testUnimplemented() public {
    //     vm.expectRevert();
    //     token.name();

    //     vm.expectRevert();
    //     token.symbol();

    //     vm.expectRevert();
    //     token.tokenURI(1);
    // }

    function testMint() public {
        token.mint(address(0xBEEF), 1337);
        assertEq(token.balanceOf(address(0xBEEF)), 1);
        assertEq(token.ownerOf(1337), address(0xBEEF));
    }

    function testApprove() public {
        token.mint(address(this), 1337);
        token.approve(address(0xBEEF), 1337);
        assertEq(token.getApproved(1337), address(0xBEEF));
    }

    function testApproveAll() public {
        token.setApprovalForAll(address(0xBEEF), true);
        assertTrue(token.isApprovedForAll(address(this), address(0xBEEF)));
    }

    function testTransferFrom() public {
        address from = address(0xABCD);

        token.mint(from, 1337);

        vm.prank(from);
        token.approve(address(this), 1337);
        token.transferFrom(from, address(0xBEEF), 1337);

        assertEq(token.getApproved(1337), address(0));
        assertEq(token.ownerOf(1337), address(0xBEEF));
        assertEq(token.balanceOf(address(0xBEEF)), 1);
        assertEq(token.balanceOf(from), 0);
    }


}
