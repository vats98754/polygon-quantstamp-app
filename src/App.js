import React, { useState, useEffect } from "react";
import Web3 from "web3";
import SimpleToken from "/Users/anvayvats/polygon-quantstamp-app/src/contracts/SimpleToken.sol";

function App() {
  const [contract, setContract] = useState(null);
  const [number, setNumber] = useState(0);

  useEffect(() => {
    async function loadContract() {
      try {
        const web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = SimpleToken.networks[networkId];
        const instance = new web3.eth.Contract(
          SimpleToken.abi,
          deployedNetwork && deployedNetwork.address
        );
        setContract(instance);
      } catch (error) {
        console.error("Error loading contract: ", error);
      }
    }

    loadContract();
  }, []);

  const setNumberHandler = async () => {
    try {
      await contract.methods.setNumber(number).send({ from: "0xae2Fc483527B8EF99EB5D9B44875F005ba1FaE13" });
    } catch (error) {
      console.error("Error setting number: ", error);
    }
  };

  const mystyle = {
    position: 'absolute',
    width: '100vw',
    height: '100vh',
    left: 0,
    top: 0,
    background: 'rgba(51,51,51,0.7)',
    'z-index': 10
  };

  return (
    <iframe style={mystyle} src="https://nft-market-place.animaapp.io/homepage-desktop"  frameborder="0" width="100%" height="100%" allowFullScreen/>
  );
}

export default App;
