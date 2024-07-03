// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenVendor.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address tokenAddress = vm.envAddress("TOKEN_ADDRESS");
        vm.startBroadcast(deployerPrivateKey);

        TokenVendor tokenVendor = new TokenVendor(tokenAddress);

        vm.stopBroadcast();
    }
}
