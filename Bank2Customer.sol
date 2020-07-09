pragma solidity ^0.6.11;

contract Bank {
    int interestRate = 20; //Percent
    
    struct account_holders {
        int balance;
    }
    
    mapping(address => account_holders) customers;
    
    receive() external payable {
        int principle = int(msg.value);
        int amount = principle + principle*interestRate/100;
        customers[msg.sender].balance += amount;
    }
    
    function lend(int askingAmount) public payable {
        int leftOverAmount = customers[msg.sender].balance - askingAmount;
        if(leftOverAmount < 0) {
            leftOverAmount += leftOverAmount*interestRate/100;
        }
        customers[msg.sender].balance = leftOverAmount;
        msg.sender.transfer(uint(askingAmount));
    }
    
    function getInterestRate() public view returns(int) {
        require(interestRate >= 0, "Improper interest rate is set");
        return interestRate;
    }
    
    function updateInterestRate(int newInterestRate) public {
        interestRate = newInterestRate;
    }
}