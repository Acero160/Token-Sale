# 🚀 Elite Token Sale - Smart Contract Project

## 📌 Overview

This project implements a **Token Sale** system using three Solidity smart contracts:
1. **EliteToken.sol** - An ERC20 token with minting and burning capabilities.
2. **TokenSale.sol** - A smart contract that facilitates the purchase of Elite Tokens.
3. **ERC20.sol** - Standard ERC20 implementation from OpenZeppelin.

## 🛠 Features

✅ **Custom ERC20 Token** with mint and burn functionalities.
✅ **Role-based Access Control** using OpenZeppelin’s `AccessControl`.
✅ **Token Sale Mechanism** with a fixed price of **1 ETH per token**.
✅ **Secure Transactions** ensuring correct pricing and transfers.

---

## 📜 Smart Contracts

### 1️⃣ EliteToken.sol

This contract implements a custom ERC20 token named **Elite Token (ELT)**:
- Uses OpenZeppelin’s `AccessControl` to define **MINTER_ROLE** and **BURNER_ROLE**.
- Allows only authorized addresses to mint or burn tokens.
- Initial supply is managed through the `mintTokens()` function.

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

import "./ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract EliteToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor() ERC20 ("ELITE","ELT") {
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
    }

    function mintTokens() public onlyRole(MINTER_ROLE) {
        _mint(msg.sender, 1000 * 10**18);
    }

    function burnTokens() public onlyRole(BURNER_ROLE) {
        _burn(msg.sender, 100 * 10**18);
    }
}
```

---

### 2️⃣ TokenSale.sol

This contract facilitates the sale of **Elite Tokens**:
- Accepts **ETH payments** in exchange for Elite Tokens.
- Ensures the correct price calculation before transferring tokens.
- Uses an interface to interact with the ERC20 token.

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

interface IERC20 {
    function transfer(address to, uint256 amount) external;
    function decimals() external view returns(uint);
}

contract TokenSale {
    uint256 public tokenPrice = 1 ether;
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function purchase() public payable {
        require(msg.value >= tokenPrice, "Not enough ETH sent");
        uint256 tokensToTransfer = msg.value / tokenPrice;
        token.transfer(msg.sender, tokensToTransfer * 10**token.decimals());
    }
}
```

---

## 🚀 How to Deploy & Use

### 🏗 Deployment Steps
1️⃣ **Deploy `EliteToken.sol`** on Ethereum or a testnet.
2️⃣ **Deploy `TokenSale.sol`**, passing the address of the deployed `EliteToken` contract.
3️⃣ **Grant `MINTER_ROLE` to the `TokenSale` contract**, allowing it to mint tokens.

### 💰 Buying Tokens
- Send ETH to the `TokenSale` contract using the `purchase()` function.
- The contract calculates the amount and transfers tokens to the buyer.

---

## 📌 Technologies Used
✅ **Solidity 0.8.14**  
✅ **OpenZeppelin Contracts**  
✅ **Ethereum / Testnet Deployment**  

---



