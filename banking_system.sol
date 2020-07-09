pragma solidity >=0.6.0;

// Assumptions:
//      - interest is only paid for full months without account interaction

contract Bank {
    uint internal fund = 100;                           // liquid fund of bank
    uint internal AuM;                                  // bank's assets under management
    uint internal lend;                                 // amount lend
    int public interestRate;                            // interest rate per year
    address public owner;                               // trusted owner of the contract
    mapping (address => int) internal balance;          // LUT of balances
    mapping (address => uint) internal lastTransaction; // LUT of last transaction for interest calculation
    
    constructor() public { 
        owner = msg.sender;
    }
    
    // Functions: check balance, deposit money in account, withdraw money from account, send money to another account
    function getBalance() public view returns(int) {    // return the balance of the current account
        return balance[msg.sender];
    }
    
    function deposit(uint amount) public payable {                  // deposit money in the current account
        int Interest = interest(balance[msg.sender]);
        balance[msg.sender] += Interest;                            // add interest to account 
        fund -= uint(Interest);                                     // subtract interest from bank's funds
        lastTransaction[msg.sender] = now;
        balance[msg.sender] += int(amount);
        AuM += amount;
    }
        
    function withdraw(uint amount) public {                         // withdraw money from the current account if funds are sufficient
        int Interest = interest(balance[msg.sender]);
        balance[msg.sender] += Interest;                            // add interest to account 
        fund -= uint(Interest);                                     // subtract interest from bank's funds
        lastTransaction[msg.sender] = now;
        require(int(amount)<=balance[msg.sender], "Balance is not sufficient"); 
        balance[msg.sender] -= int(amount);
        AuM -= amount;
        msg.sender.transfer(amount);
    }
    
    function interest(int amount) internal view returns(int) {  // calculate interest from last transaction to now, assuming monthly interest
        uint months = (now-lastTransaction[msg.sender])/60/60/24/30;
        int Interest = amount*(1+interestRate/12)**(months) - amount;
        return Interest;
    }
    
    //TODO: function send money to another account within bank
    //TODO: integrate loan functionality
    
}

//TODO: Create instances of banks with class inheritance
