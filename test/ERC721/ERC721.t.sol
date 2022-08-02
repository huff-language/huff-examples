// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "foundry-huff/HuffDeployer.sol";

interface ERC721 {
    
}

contract ERC721Test is Test {
    ERC721 erc721;

    /// @notice Set up the testing suite
    function setUp() public {
        erc721 = ERC721(HuffDeployer.deploy("ERC721/ERC721"));
    }

}