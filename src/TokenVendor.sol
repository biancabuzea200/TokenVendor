// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.2;

interface TokenInterface {
    function mint(address account, uint256 amount) external;
}

interface IChronicle {
    function read() external view returns (uint256 value);
}

// https://github.com/chronicleprotocol/self-kisser/blob/main/src/ISelfKisser.sol
interface ISelfKisser {
    /// @notice Kisses caller on oracle `oracle`.
    function selfKiss(address oracle) external;
}

contract TokenVendor {
    IChronicle public chronicle; // the price feed we will use
    ISelfKisser public selfKisser;
    TokenInterface public minter;
    address public owner;

    constructor(address tokenAddress) {
        minter = TokenInterface(tokenAddress);

        /**
         * @notice The SelfKisser granting access to Chronicle oracles.
         * SelfKisser_1: 0x0Dcc19657007713483A5cA76e6A7bbe5f56EA37d
         * Network: Sepolia
         */
        selfKisser = ISelfKisser(address(0x0Dcc19657007713483A5cA76e6A7bbe5f56EA37d));

        /**
         * Network: Sepolia
         * Aggregator: ETH/USD
         * Address: 0xdd6D76262Fd7BdDe428dcfCd94386EbAe0151603
         */
        chronicle = IChronicle(address(0xdd6D76262Fd7BdDe428dcfCd94386EbAe0151603));
        selfKisser.selfKiss(address(chronicle));
        owner = msg.sender;
    }

    function _read() internal view returns (uint256 val) {
        val = chronicle.read();
    }

    function tokenAmount(uint256 amountWei) public view returns (uint256) {
        // Send amountETH, how many USD I have
        uint256 ethUsd = _read(); // Price feed has 10**18 decimal places
        uint256 amountUSD = (amountWei * ethUsd) / 10 ** 18; // Price is 10**18
        uint256 amountToken = amountUSD / 10 ** 18; // Divide to convert from wei to ETH
        return amountToken;
    }

    receive() external payable {
        uint256 amountToken = tokenAmount(msg.value);
        minter.mint(msg.sender, amountToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() external onlyOwner {
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }
}
