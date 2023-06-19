// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is ERC20 {
    constructor() ERC20("SimpleToken", "ST") {
        _mint(msg.sender, 1000000000000000000000000); // Mint 1,000,000 tokens
    }
}
