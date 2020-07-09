pragma solidity >=0.6.0;

contract Bank {
    uint internal fund;                             // fund of bank
    uint internal lend;                             // amount lend
    uint public interestRate;
    address public owner;                           // trusted owner of the contract
    mapping (address => int) internal balance;
    
    constructor() public { 
        owner = msg.sender;
    }
    
    // Functions: check balance, deposit money in account, withdraw money from account, send money to another account
    function getBalance() public view returns(int) {    // return the balance of the current account
        return balance[msg.sender];
    }
    
    function deposit(int amount) public payable {       // deposit money in the current account
        balance[msg.sender] += amount;
    }
        
    function withdraw(int amount) public {              // withdraw money from the current account if funds are sufficient
        require(amount<=balance[msg.sender]); 
        balance[msg.sender] -= amount;
    }
    
}
