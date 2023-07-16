
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
      "ba7a7faa4cbb734ee498a3173b3b6ff4c31ded5144ddeb3b0558e17b2c204a28"
      ]
    },
    mainnet: {
      url: 'https://api.avax.network/ext/bc/C/rpc',
      gasPrice: 225000000000,
      chainId: 43114,
      accounts: [
        "ba7a7faa4cbb734ee498a3173b3b6ff4c31ded5144ddeb3b0558e17b2c204a28"
      ]
    }
  },
  etherscan: {
    apiKey: "C77JCDPB6N788JTK9UW8EUYEJFBC7PFIFR",
  }
}



