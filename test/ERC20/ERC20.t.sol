// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "foundry-huff/HuffDeployer.sol";

import {IERC20} from "src/interfaces/IERC20.sol";

/// @author These tests have been adapted from Solmate and include additional coverage.
contract ERC20Test is Test {
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    event NewOwner(address indexed oldOwner, address indexed newOwner);
    event NewPendingOwner(address indexed oldOwner, address indexed newOwner);

    IERC20 token;

    address public bob = address(0xB0B);
    address public deployer = address(0xC0DE60D);

    bytes32 constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    // "Token"
    string public constant NAME = "Token";
    bytes32 public constant META_NAME = bytes32(0x546f6b656e000000000000000000000000000000000000000000000000000000);
    uint256 public constant META_NAME_LENGTH = uint256(0x5);

    // "TKN"
    string public constant SYMBOL = "TKN";
    bytes32 public constant META_SYMBOL = bytes32(0x544B4E0000000000000000000000000000000000000000000000000000000000);
    uint256 public constant META_SYMBOL_LENGTH = uint256(0x3);

    // 18
    uint256 public constant DECIMALS = uint256(0x12);

    function setUp() public {
        vm.startPrank(deployer);
        address tokenAddress = HuffDeployer.config().with_args(
            bytes.concat(abi.encode("Token"), abi.encode("TKN"), abi.encode(DECIMALS))
        ).deploy("ERC20");
        token = IERC20(tokenAddress);
        vm.stopPrank();
    }

    function testMockERC20Metadata() public {
        string memory tokenName = token.name();
        string memory tokenSymbol = token.symbol();
        uint256 tokenDecimals = token.decimals();

        assertEq(keccak256(abi.encode(tokenName)), keccak256(abi.encode(NAME)));
        assertEq(keccak256(abi.encode(tokenSymbol)), keccak256(abi.encode(SYMBOL)));
        assertEq(tokenDecimals, DECIMALS);
    }

    function testNonPayable() public {
        vm.deal(address(this), 10 ether);

        // mint
        (bool success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.mint.selector, address(0xBEEF), 1e18));
        assertFalse(success);
        // burn
        (success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.burn.selector, address(0xBEEF), 1e18));
        assertFalse(success);
        // approve
        (success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.approve.selector, address(0xBEEF), 1e18));
        assertFalse(success);
        // transfer
        (success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.transfer.selector, address(0xBEEF), 1e18));
        // transferFrom
        (success,) = address(token).call{value: 1 ether}(
            abi.encodeWithSelector(token.transferFrom.selector, address(this), address(0xBEEF), 1e18)
        );
        assertFalse(success);
        // name
        (success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.name.selector, address(0xBEEF), 1e18));
        assertFalse(success);
        // balanceOf
        (success,) =
            address(token).call{value: 1 ether}(abi.encodeWithSelector(token.balanceOf.selector, address(0xBEEF)));
        assertFalse(success);
        // no data
        (success,) = address(token).call{value: 1 ether}(abi.encode(0x0));
        assertFalse(success);
    }

    function testMetadata() public {
        string memory tokenName = token.name();
        string memory tokenSymbol = token.symbol();
        uint256 tokenDecimals = token.decimals();

        assertEq(keccak256(abi.encode(tokenName)), keccak256(abi.encode(NAME)));
        assertEq(keccak256(abi.encode(tokenSymbol)), keccak256(abi.encode(SYMBOL)));
        assertEq(tokenDecimals, DECIMALS);
    }

    function testMint() public {
        token.mint(address(0xBEEF), 1e18);

        assertEq(token.totalSupply(), 1e18);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testBurn() public {
        token.mint(address(0xBEEF), 1e18);
        token.burn(address(0xBEEF), 0.9e18);

        assertEq(token.totalSupply(), 1e18 - 0.9e18);
        assertEq(token.balanceOf(address(0xBEEF)), 0.1e18);
    }

    function testApprove() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(address(this), address(0xBEEF), 1e18);
        assertTrue(token.approve(address(0xBEEF), 1e18));
        assertEq(token.allowance(address(this), address(0xBEEF)), 1e18);
    }

    function testTransfer() public {
        token.mint(address(this), 1e18);

        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(0xBEEF), 1e18);

        assertTrue(token.transfer(address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testTransferFrom1() public {
        address from = address(0xABCD);

        token.mint(from, 1e18);

        vm.prank(from);
        token.approve(address(this), 1e18);

        assertTrue(token.transferFrom(from, address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.allowance(from, address(this)), 0);

        assertEq(token.balanceOf(from), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testInfiniteApproveTransferFrom() public {
        address from = address(0xABCD);

        token.mint(from, 1e18);

        vm.prank(from);
        token.approve(address(this), type(uint256).max);

        assertTrue(token.transferFrom(from, address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.allowance(from, address(this)), type(uint256).max);

        assertEq(token.balanceOf(from), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testFailTransferInsufficientBalance() public {
        token.mint(address(this), 0.9e18);
        token.transfer(address(0xBEEF), 1e18);
    }

    function testFailTransferFromInsufficientAllowance() public {
        address from = address(0xABCD);

        token.mint(from, 1e18);

        vm.prank(from);
        token.approve(address(this), 0.9e18);

        token.transferFrom(from, address(0xBEEF), 1e18);
    }

    function testFailTransferFromInsufficientBalance() public {
        address from = address(0xABCD);

        token.mint(from, 0.9e18);

        vm.prank(from);
        token.approve(address(this), 1e18);

        token.transferFrom(from, address(0xBEEF), 1e18);
    }

    function testMint(address from, uint256 amount) public {
        token.mint(from, amount);

        assertEq(token.totalSupply(), amount);
        assertEq(token.balanceOf(from), amount);
    }

    function testBurn(address from, uint256 mintAmount, uint256 burnAmount) public {
        burnAmount = bound(burnAmount, 0, mintAmount);

        token.mint(from, mintAmount);
        token.burn(from, burnAmount);

        assertEq(token.totalSupply(), mintAmount - burnAmount);
        assertEq(token.balanceOf(from), mintAmount - burnAmount);
    }

    function testApprove(address to, uint256 amount) public {
        assertTrue(token.approve(to, amount));

        assertEq(token.allowance(address(this), to), amount);
    }

    function testTransfer(address from, uint256 amount) public {
        token.mint(address(this), amount);

        assertTrue(token.transfer(from, amount));
        assertEq(token.totalSupply(), amount);

        if (address(this) == from) {
            assertEq(token.balanceOf(address(this)), amount);
        } else {
            assertEq(token.balanceOf(address(this)), 0);
            assertEq(token.balanceOf(from), amount);
        }
    }

    function testTransferFrom(address to, uint256 approval, uint256 amount) public {
        amount = bound(amount, 0, approval);

        address from = address(0xABCD);

        token.mint(from, amount);

        vm.prank(from);
        token.approve(address(this), approval);

        assertTrue(token.transferFrom(from, to, amount));
        assertEq(token.totalSupply(), amount);

        uint256 app = from == address(this) || approval == type(uint256).max ? approval : approval - amount;
        assertEq(token.allowance(from, address(this)), app);

        if (from == to) {
            assertEq(token.balanceOf(from), amount);
        } else {
            assertEq(token.balanceOf(from), 0);
            assertEq(token.balanceOf(to), amount);
        }
    }

    function testFailBurnInsufficientBalance(address to, uint256 mintAmount, uint256 burnAmount) public {
        burnAmount = bound(burnAmount, mintAmount + 1, type(uint256).max);

        token.mint(to, mintAmount);
        token.burn(to, burnAmount);
    }

    function testFailTransferInsufficientBalance(address to, uint256 mintAmount, uint256 sendAmount) public {
        sendAmount = bound(sendAmount, mintAmount + 1, type(uint256).max);

        token.mint(address(this), mintAmount);
        token.transfer(to, sendAmount);
    }

    function testFailTransferFromInsufficientAllowance(address to, uint256 approval, uint256 amount) public {
        amount = bound(amount, approval + 1, type(uint256).max);

        address from = address(0xABCD);

        token.mint(from, amount);

        vm.prank(from);
        token.approve(address(this), approval);

        token.transferFrom(from, to, amount);
    }

    function testFailTransferFromInsufficientBalance(address to, uint256 mintAmount, uint256 sendAmount) public {
        sendAmount = bound(sendAmount, mintAmount + 1, type(uint256).max);

        address from = address(0xABCD);

        token.mint(from, mintAmount);

        vm.prank(from);
        token.approve(address(this), sendAmount);

        token.transferFrom(from, to, sendAmount);
    }

    function testPermit() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        bytes32 inner_hash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 0, block.timestamp));

        // bytes32 actualDomainSeparator = keccak256(
        //     abi.encode(
        //         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
        //         keccak256(abi.encode(0x546f6b656e000000000000000000000000000000000000000000000000000000)),
        //         keccak256("1"),
        //         block.chainid,
        //         address(token)
        //     )
        // );

        bytes32 outer_hash = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), inner_hash));

        // Create the signature
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, outer_hash);

        // Permit!
        vm.expectEmit(true, true, false, true);
        emit Approval(owner, address(0xCAFE), 1e18);
        token.permit(owner, address(0xCAFE), 1e18, block.timestamp, v, r, s);

        // Expect the allowance to be set for the spender and the nonce to be incremented
        assertEq(token.allowance(owner, address(0xCAFE)), 1e18);
        assertEq(token.nonces(owner), 1);
    }

    function testFailPermitBadNonce() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 1, block.timestamp))
                )
            )
        );

        token.permit(owner, address(0xCAFE), 1e18, block.timestamp, v, r, s);
    }

    function testFailPermitBadDeadline() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 0, block.timestamp))
                )
            )
        );

        token.permit(owner, address(0xCAFE), 1e18, block.timestamp + 1, v, r, s);
    }

    function testPermitPastDeadline() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 0, block.timestamp - 1))
                )
            )
        );

        vm.expectRevert(bytes("PERMIT_DEADLINE_EXPIRED"));
        token.permit(owner, address(0xCAFE), 1e18, block.timestamp - 1, v, r, s);
    }

    function testFailPermitReplay() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 0, block.timestamp))
                )
            )
        );

        token.permit(owner, address(0xCAFE), 1e18, block.timestamp, v, r, s);
        token.permit(owner, address(0xCAFE), 1e18, block.timestamp, v, r, s);
    }

    function testInvalidSigner() public {
        uint256 privateKey = 0xBEEF;
        address owner = vm.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xCAFE), 1e18, 0, block.timestamp))
                )
            )
        );

        vm.expectRevert(bytes("INVALID_SIGNER"));
        token.permit(address(0xCAFE), address(0xCAFE), 1e18, block.timestamp, v, r, s);
    }
}
