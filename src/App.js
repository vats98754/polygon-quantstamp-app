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

  return (
    <div>
      <h1>Quantstamp App</h1>
      <input type="number" value={number} onChange={(e) => setNumber(e.target.value)} />
      <button onClick={setNumberHandler}>Set Number</button>
    </div>
  );
}

export default App;
