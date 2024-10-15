// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BondingCurveToken is ERC20 {
    uint256 public reserveTokenBalance;
    uint256 public reservePrice;
    uint256 public scalingFactor;

    event TokensPurchased(address indexed buyer, uint256 amountSpent, uint256 tokensMinted);
    event TokensSold(address indexed seller, uint256 tokensSold, uint256 etherReturned);

    constructor(string memory name, string memory symbol, uint256 initialReservePrice) 
        ERC20(name, symbol) 
    {
        reservePrice = initialReservePrice;
        scalingFactor = 1000;
    }

    function buy() external payable {
        require(msg.value > 0, "Must send ETH to buy tokens");

        uint256 currentSupply = totalSupply(); 
        uint256 tokensToMint = (msg.value * scalingFactor * (currentSupply + 1)) / reservePrice;

        reserveTokenBalance += msg.value;

        _mint(msg.sender, tokensToMint);

        emit TokensPurchased(msg.sender, msg.value, tokensToMint);
    }

    function sell(uint256 amount) external {
        require(amount > 0, "Must sell more than 0 tokens");
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");

        uint256 etherToReturn = (amount * reservePrice) / scalingFactor; 

        require(etherToReturn <= reserveTokenBalance, "Not enough reserves to sell tokens");

        reserveTokenBalance -= etherToReturn;
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(etherToReturn);

        emit TokensSold(msg.sender, amount, etherToReturn);
    }
}
