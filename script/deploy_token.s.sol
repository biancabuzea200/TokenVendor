// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerPublicKey = vm.envAddress("PUBLIC_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Token token = new Token(deployerPublicKey, deployerPublicKey);

        vm.stopBroadcast();
    }
}
