// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { ERC721TokenReceiver } from "solmate/tokens/ERC721.sol";

/// @title ERC721 Token Recipient that Reverts
contract RevertingERC721Recipient is ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public virtual override returns (bytes4) {
        revert(string(abi.encodePacked(ERC721TokenReceiver.onERC721Received.selector)));
    }
}
