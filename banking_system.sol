pragma solidity >=0.6.0;

contract Bank {
    uint internal fund;                             // fund of bank
    uint internal lend;                             // amount lend
    uint public interestRate;
    address public owner;                           // trusted owner of the contract
    mapping (address => uint) internal balance;
    
    constructor() public { 
        owner = msg.sender;
    }
    
    // functions: check balance, deposit money in account, withdraw money from account, send money to another account
}
