// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TokenVendor.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        TokenVendor tokenVendor = new TokenVendor(address('0x9C789164dc8b39B4B05FF6b161c62636589C87E6'));

        vm.stopBroadcast();
    }
}
