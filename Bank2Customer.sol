pragma solidity ^0.6.11;

contract Bank {
    uint private interestRate; //in %
    address private owner;
    uint private bankReserve;

    constructor() public {
        owner = msg.sender;
        bankReserve = 1000;
        interestRate = 20;
    }

    struct account_holders {
        uint accountBal;
        uint lendAmount;
        uint lastUpdateTime;
    }

    mapping(address => account_holders) customers;

    function withdraw(uint withdrawAmt) public payable {
        require(withdrawAmt <= customers[msg.sender].accountBal);
        if (withdrawAmt > bankReserve) {
            //TODO take from another bank
        }
        customers[msg.sender].accountBal -= withdrawAmt;
        customers[msg.sender].lastUpdateTime = now;
        msg.sender.transfer(withdrawAmt);
        bankReserve -= withdrawAmt;
    }

    function deposit() external payable {
        uint amount = interest(msg.value);
        customers[msg.sender].accountBal += amount;
        bankReserve += amount;
    }

    function lend(uint lendAmt) public payable {
        if (lendAmt > bankReserve) {
            //TODO take from another bank
        }
        uint amount = interest(lendAmt);
        customers[msg.sender].lendAmount += amount;
        msg.sender.transfer(uint(lendAmt));
        bankReserve -= lendAmt;
    }

    function repayLoan() external payable {
        uint amount = msg.value;
        customers[msg.sender].lendAmount += amount;
        customers[msg.sender].lastUpdateTime = now;
        bankReserve += amount;
    }

    function getInterestRate() public view returns(uint) {
        require(interestRate >= 0, "Improper interest rate is set");
        return interestRate;
    }

    function updateInterestRate(uint newInterestRate) public {
        require(msg.sender == owner, "You are not allowed to update the interest rate");
        interestRate = newInterestRate;
    }

    function internalTransfer(address destination, uint amount) external {
        require(amount <= customers[msg.sender].accountBal, "Balance is not sufficient");
        customers[msg.sender].accountBal = interest(customers[msg.sender].accountBal) - amount;
        customers[destination].accountBal = interest(customers[destination].accountBal) + amount;
    }
    
    function interest(uint principle) private returns(uint) {
        uint months = uint(ufixed(now-customers[msg.sender].lastUpdateTime)/(3600*24*30));
        ufixed interest = ufixed(principle*interestRate)/1200;
        customers[msg.sender].lastUpdateTime = now;
        return principle + uint(interest);
    }
}
