## Chronicle at EthGlobal Brussels Workshop - Create a TokenVendor Machine for Your Token
In this workshop, we will create our own ERC20 token and design a TokenVendor to distribute it. The TokenVendor will accept ETH and, in exchange, distribute our token to the sender. To determine how many tokens to distribute per ETH, the TokenVendor will need the current ETH/USD price that we will get using a [Chronicle Oracle](https://sepolia.etherscan.io/address/0xdd6D76262Fd7BdDe428dcfCd94386EbAe0151603#code). 

This workshop use Ethereum Sepolia, however you can adapt it for your favourite chain. You can find a list of supported chains [here](https://docs.chroniclelabs.org/hackathons/eth-global-brussels-hackathon) for Testnet, or directly from the [Dashboard](https://chroniclelabs.org/dashboard/oracles) for Mainnet.

# How to Run it?

## Make sure to rename the .env.example to .env and add your environment variables

## Export the environment variables
```
source .env 
```


## Build the projects's smart contracts
```
forge build
```


## Deploy the Token.sol to Sepolia
```
forge script --chain sepolia script/deploy_token.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```

## Deploy TokenVendor.sol to Sepolia
```
forge script --chain sepolia script/deploy_tokenVendor.s.sol --rpc-url $SEPOLIA_RPC_URL --broadcast --verify -vvvv
```

## Grant the MINTER role to the TokenVendor
 ```
 cast send 0xD7A9066BBEed1fEb37105A1E53b90A6B62cbDEE2 "grantRole(bytes32 role, address account)" 9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6  $TOKEN_VENDOR_ADDRESS   --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
  ``` 
 -  9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6 is keccak256("MINTER_ROLE")
 -  0xD7A9066BBEed1fEb37105A1E53b90A6B62cbDEE2 represents the deployed Token.sol on Sepolia


## Send some ETH to the TokenVendor's address in exchange for our ERC20 Token
 ```
 cast send $TOKEN_VENDOR_ADDRESS  --value 0.01ether  --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
 ```