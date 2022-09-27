// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/// @notice Interface of an ERC721 token with minting permissions
interface IERC721 {
    event Approval(address, address, uint256);
    event ApprovalForAll(address, address, bool);
    event Transfer(address, address, uint256);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256) external returns (string memory);

    function mint(address, uint256) external payable;
    function burn(uint256) external;

    function transfer(address, uint256) external;
    function transferFrom(address, address, uint256) external;
    function safeTransferFrom(address, address, uint256) external;
    function safeTransferFrom(address, address, uint256, bytes calldata) external;

    function approve(address, uint256) external;
    function setApprovalForAll(address, bool) external;

    function getApproved(uint256) external returns (address);
    function isApprovedForAll(address, address) external view returns (bool);
    function ownerOf(uint256) external view returns (address);
    function balanceOf(address) external view returns (uint256);
    function supportsInterface(bytes4) external view returns (bool);

    function safeMint(address to, uint256 tokenId, bytes memory data) external;
    function safeMint(address to, uint256 tokenId) external;
}
