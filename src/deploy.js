const Web3 = require('web3');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const mnemonic = 'YOUR_METAMASK_MNEMONIC';
const infuraApiKey = 'YOUR_INFURA_API_KEY';
const polygonRpc = 'https://polygon-mainnet.infura.io/v3/' + infuraApiKey;

const provider = new HDWalletProvider({
    mnemonic: {
        phrase: mnemonic,
    },
    providerOrUrl: polygonRpc,
});

const web3 = new Web3(provider);

// Contract deployment code
const contractData = require('./SimpleToken.json');
const contractAbi = contractData.abi;
const contractBytecode = contractData.bytecode;

async function deployContract() {
    const accounts = await web3.eth.getAccounts();
    const account = accounts[0];

    const gasPrice = await web3.eth.getGasPrice();
    const gasEstimate = await web3.eth.estimateGas({ data: contractBytecode });

    const contract = new web3.eth.Contract(contractAbi);
    const deployTransaction = contract.deploy({
        data: contractBytecode,
    });

    const signedTransaction = await web3.eth.accounts.signTransaction(
        {
            from: account,
            data: deployTransaction.encodeABI(),
            gas: gasEstimate,
            gasPrice,
        },
        mnemonic
    );

    const receipt = await web3.eth.sendSignedTransaction(signedTransaction.rawTransaction);
    console.log('Contract deployed at address:', receipt.contractAddress);
}

deployContract();
