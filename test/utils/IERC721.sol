// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

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
