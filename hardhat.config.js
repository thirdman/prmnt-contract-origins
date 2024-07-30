require("@nomicfoundation/hardhat-toolbox");
// require("dotenv").config();
// require("@nomiclabs/hardhat-ethers");

// require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("solidity-coverage");
require("./tasks/block-number");
require('hardhat-abi-exporter');



/** @type import('hardhat/config').HardhatUserConfig */
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL || "";
const PRIVATE_KEY = process.env.PRIVATE_KEY || ""
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""


module.exports = {
  
  solidity: {
    version: "0.8.24", 
    settings: {
      optimizer: {
        enabled: true,
        runs: 400,
      },
    },
  },


  defaultNetwork: 'hardhat',
  networks: {
    // goerli: {
    //   url: GOERLI_RPC_URL,
    //   accounts: [PRIVATE_KEY],
    //   chainId: 5
    // },
    localhost: {
      url: 'http://127.0.0.1:8545/',
      chainId: 31337,
      // accounts: [] already exist thanks to hardhat
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY
  },
  gasReporter: {
    enabled: true,
    outputFile: 'gas-report.txt',
    noColors: true,
    currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,
    // token: 'MATIC'
  },
  
  contractSizer: {
    alphaSort: false,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: false,
    // only: [':ERC20$'],
  },
  abiExporter: [
    {
      path: './abi/pretty',
      // pretty: true,
      runOnCompile: true,
      clear: true,
      flat: false,
      format: 'json'
    },
  ]
};
