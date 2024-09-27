// GameToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GameToken {

    uint public totalTokens;
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;
    
    string public tokenName = "GameCoin";
    string public tokenSymbol = "GMC";
    uint8 public tokenDecimals = 18;

    event Transfer(address indexed sender, address indexed receiver, uint amount);
    event Approval(address indexed owner, address indexed delegate, uint amount);

    function transfer(address recipient, uint amount) external returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address delegate, uint amount) external returns (bool) {
        allowed[msg.sender][delegate] = amount;
        
        emit Approval(msg.sender, delegate, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
        require(balances[sender] >= amount, "Insufficient balance");
        require(allowed[sender][msg.sender] >= amount, "Allowance exceeded");
        
        allowed[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external {
        balances[msg.sender] += amount;
        totalTokens += amount;
        
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        totalTokens -= amount;
        
        emit Transfer(msg.sender, address(0), amount);
    }
}