# Degen Token (ERC-20): Unlocking the Future of Gaming

This project demonstrates how to create a ERC20 token and deploy it on the Avalanche Fuji Testnet. And Verify the smart-contract on Snowtrace.

## Description

This project represents a smart contract called "degen" which is an ERC20 token contract with additional functionality. Here's a brief description of its features:The contract inherits from two other contracts, ERC20 and Ownable. The ERC20 contract provides standard ERC20 token functionality, while the Ownable contract allows for ownership control of the contract.The constructor initializes the token with the name "Degen" and symbol "DGN".The mint function allows the contract owner to mint new tokens and assign them to a specified address.
The transfer function overrides the ERC20 transfer function to add a custom requirement that the sender must have sufficient balance before transferring tokens.
The redeem function allows the caller to redeem an item from the storehouse by providing the item number. Depending on the item number, different actions are performed such as burning tokens, minting additional tokens, or applying conditional logic based on the last digit of the caller's address.
Overall, this contract represents a token with additional features such as minting, burning, and a storehouse for redeeming items using tokens. It demonstrates various concepts of ERC20 tokens and ownership control.

This contract is added to the hardhat project and is compiled on avalanche fujj test network. And the contract is verified on snowtrace.
## Getting Started

### Project Setup

1. Create a folder for your new project, and run npm init
 cd ./your-project
 npm init -y
2. Install hardhat
 npm install --save-dev hardhat
3. Initialize your hardhat project
 npx hardhat
4. For the smart contract section, we'll create a Points ERC20 token using OpenZeppelin, and then make it mintable.
   npm install @openzeppelin/contracts
5. After that's inside the contracts folder, we'll create a degen.sol file, and put the solidity code inside it.

### Project Configuration

To enable users to test their smart contracts on the local network with data from Avalanche Mainnet.
1. Open hardhat.config.js file and add the below code:
   
 ```

require("@nomicfoundation/hardhat-toolbox");

const FORK_FUJI = true;
const FORK_MAINNET = true;
let forkingData = undefined;

if (FORK_MAINNET) {
  forkingData = {
    url: "https://api.avax.network/ext/bc/C/rpcc",
  };
}
if (FORK_FUJI) {
  forkingData = {
    url: "https://api.avax-test.network/ext/bc/C/rpc",
  };
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    hardhat: {
      gasPrice: 225000000000,
      chainId: !forkingData ? 43112 : undefined, //Only specify a chainId if we are not forking
      forking: forkingData
    },
    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43113,
      accounts: [
      "YOUR PRIVATE KEY"
      ]
    },
    mainnet: {
      url: 'https://api.avax.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: [
        "YOUR PRIVATE KEY"
      ]
    }
  },
  etherscan: {
    apiKey: "YOUR API KEY",
  }
}




```
    

### Scripts

One script, the deploy.js script, to deploy the degen token smart contract to the chain that we want.

```
// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
async function main() {
  const Degen = await ethers.getContractFactory("degen")

  // Start deployment, returning a promise that resolves to a contract object
  const degen= await Degen.deploy()
  await degen.deployed()
  console.log("Contract deployed to address:", degen.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
```

### Deploying

1. get some Testnet AVAX from the Faucet. You can get that here: https://faucet.avax.network/.
2. add the network to your metamask wallet. Here’s all the information that a wallet like Metamask requires to connect to a chain:

Network Name: Avalanche Fuji C-Chain 

New RPC URL: https://api.avax-test.network/ext/bc/C/rpc

ChainID: 43113 Symbol: 

AVAX Explorer: https://testnet.snowtrace.io/

3. Go to your terminal and type:
 
  npx hardhat run scripts/deploy.js --network fuji
  
 this output will be displayed:  Points token deployed to <YOUR TOKEN ADDRESS>

4. Verifying:

   npx hardhat verify <YOUR TOKEN ADDRESS> --network fuji
### Executing program

To run the program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., HelloWorld.sol). Copy and paste the following code into the file:

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract degen is ERC20, Ownable {

    struct Item {
        string name;
    }

    mapping(uint256 => Item) public items;

    constructor() ERC20("Degen", "DGN") {}

    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(balanceOf(msg.sender) >= value, "Balance is low!!");
        _transfer(msg.sender, to, value);
        return true;
    }

    function balance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burn(uint256 value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _burn(msg.sender, value);
    }

    function degenstorehouse() public  {
        // Add items to the storehouse
        items[1] = Item("DGN MEMBERSHIP LOGO");                 
        items[2] = Item("DGN CARD");               
        items[3] = Item("DGN SURPRISE");                 
                
    }


    function getLastDigit() public view returns (uint256) {
        return uint256(uint160(msg.sender)) % 10;
    }

    function redeem(uint256 itemNo) public {
        require(itemNo >= 1 && itemNo <= 3, "Invalid item number");
        //uint256 price = items[itemNo].price;
        
    if (itemNo == 1){
    uint price= 100;
    require(balanceOf(msg.sender) >= price, "Insufficient balance");

        _burn(msg.sender, price);
        uint256 additionalTokens = 50;
        _mint(msg.sender, additionalTokens);

        // Add logic here to distribute the item to the user
    }

    if (itemNo == 2){
        uint price= 20;
        require(balanceOf(msg.sender) >= price, "Insufficient balance");
         _burn(msg.sender, price);
        
        

    }

    if (itemNo == 3){
        
                uint256 price = 150;
                require(balanceOf(msg.sender) >= price, "Insufficient balance");
                uint256 lastDigit = getLastDigit();

            if (lastDigit >= 5) {
                // If the last digit is 5 or greater, transfer additional tokens
                uint256 additionalTokens = 75;
                _mint(msg.sender, additionalTokens);
            }

            _burn(msg.sender, price);
        }       
    }
}

```
After the successful compilation of the code:
#### Under the environment section, select Inject provider which connects it to the metamassk. copy the token address from the terminal and add it to address section below the deploy option.

Deploy it .Use the same address to mint the tokens. For burning and transfering of the tokens use can you different accounts, but ensure that they have enough balance(no. of tokens). Also reedem the tokens by selecting different items.

#### go to snowtrace and type the address there and see the deployed functions.

## Authors

Contributors names and contact info

[B Devi](devibattini@gmail.com)


## License

This project is licensed under the MIT  License - see the LICENSE.md file for details
