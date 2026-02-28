# Flash Loan Arbitrage Bot

A high-performance Solidity smart contract designed for executing atomic arbitrage across decentralized exchanges (DEXs) using Uniswap V3 Flash Loans.

## How it Works
1. **Borrow:** The contract borrows a specific amount of assets from a Uniswap V3 pool using a Flash Loan (zero collateral required).
2. **Swap:** It automatically triggers a `uniswapV3FlashCallback` where you execute your arbitrage logic (e.g., buying on Uniswap and selling on Sushiswap).
3. **Repay:** The contract calculates the debt plus fee, repays the loan, and keeps the remaining profit.

## Core Components
* **Uniswap V3 Integration:** Uses the latest `IUniswapV3Pool` and `IUniswapV3SwapRouter` interfaces.
* **Profit Safety Check:** The transaction will automatically revert if the final profit does not cover gas costs and loan fees.
* **Access Control:** Restricted to the contract owner to prevent third-party execution of your strategies.

## Prerequisites
* Solidity ^0.8.20
* A funded wallet on a supported EVM chain (Mainnet, Arbitrum, Optimism) for gas fees.
