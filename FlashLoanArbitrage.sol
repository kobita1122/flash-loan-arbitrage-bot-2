// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV3Pool {
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}

interface IUniswapV3FlashCallback {
    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external;
}

contract FlashLoanArbitrage is IUniswapV3FlashCallback, Ownable {
    constructor() Ownable(msg.sender) {}

    struct FlashCallbackData {
        uint256 amount0;
        uint256 amount1;
        address payer;
        address pool;
    }

    function initFlashLoan(
        address pool,
        uint256 amount0,
        uint256 amount1
    ) external onlyOwner {
        bytes memory data = abi.encode(
            FlashCallbackData({
                amount0: amount0,
                amount1: amount1,
                payer: msg.sender,
                pool: pool
            })
        );

        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, data);
    }

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override {
        FlashCallbackData memory decoded = abi.decode(data, (FlashCallbackData));
        require(msg.sender == decoded.pool, "Invalid callback source");

        // --- ARBITRAGE LOGIC START ---
        // 1. You now have 'decoded.amount0' or 'amount1' in this contract.
        // 2. Perform your swaps here (e.g., Swap Token A for Token B on Dex 2).
        // 3. Ensure the final balance of the borrowed token is >= (amount + fee).
        // --- ARBITRAGE LOGIC END ---

        // Repay the loan
        if (fee0 > 0) {
            IERC20(IUniswapV3Pool(msg.sender).token0()).transfer(
                msg.sender, 
                decoded.amount0 + fee0
            );
        }
        if (fee1 > 0) {
            IERC20(IUniswapV3Pool(msg.sender).token1()).transfer(
                msg.sender, 
                decoded.amount1 + fee1
            );
        }
    }

    function withdrawToken(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(msg.sender, balance);
    }
}
