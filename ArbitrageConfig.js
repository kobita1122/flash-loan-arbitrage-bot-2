module.exports = {
    networks: {
        mainnet: {
            poolAddress: "0x8ad599c3A0ff1De082011EFDDc58f1908eb6e6D8", // USDC/ETH Pool
            token0: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", // USDC
            token1: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"  // WETH
        }
    },
    strategy: {
        minProfit: "0.05", // Minimum ETH profit to execute
        loanAmount: "100000" // Amount of USDC to borrow
    }
};
