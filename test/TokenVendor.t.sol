// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vm} from "forge-std/Vm.sol";
import {Test} from "forge-std/Test.sol";

import {Token} from "../src/Token.sol";
import {TokenVendor} from "../src/TokenVendor.sol";

contract TokenVendorTest is Test {
    Token token;
    TokenVendor tokenVendor;

    address admin;
    address minter;

    function setUp() public {
        vm.createSelectFork("https://gateway.tenderly.co/public/sepolia");

        admin = makeAddr("admin");
        minter = makeAddr("minter");

        token = new Token(admin, minter);
        tokenVendor = new TokenVendor(address(token));

        // Grant tokenVendor minter role.
        vm.prank(admin);
        token.grantRole(keccak256("MINTER_ROLE"), address(tokenVendor));
    }

    function test_DepositETH() public {
        // Make user holding 1 ETH.
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        // Let user deposit 1 ETH into tokenVendor.
        vm.prank(user);
        (bool ok,) = address(tokenVendor).call{value: 1 ether}("");
        require(ok, "Deposi failed");

        // Expect user to have received tokens.
        assertTrue(token.balanceOf(user) != 0);
    }
}
