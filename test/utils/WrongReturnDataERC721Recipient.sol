// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { ERC721TokenReceiver } from "solmate/tokens/ERC721.sol";

/// @title ERC721 Token Recipient that returns the wrong bytes4 function selector
contract WrongReturnDataERC721Recipient is ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public virtual override returns (bytes4) {
        return 0xCAFEBEEF;
    }
}
