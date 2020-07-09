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
        bool isBank;
    }

    mapping(address => account_holders) customers;

    function withdraw(uint withdrawAmt) public payable {
        require(withdrawAmt <= customers[msg.sender].accountBal);
        customers[msg.sender].accountBal -= withdrawAmt;
        msg.sender.transfer(withdrawAmt);
        bankReserve -= withdrawAmt;
    }

    function deposit() external payable {
        uint amount = uint(ufixed(msg.value) * (1 + ufixed(interestRate)/100));
        customers[msg.sender].accountBal += amount;
        bankReserve += amount;
    }

    function lend(uint lendAmt) public payable {
        uint amount = uint(ufixed(lendAmt) * (1 + ufixed(interestRate/100)));
        customers[msg.sender].lendAmount += amount;
        msg.sender.transfer(uint(lendAmt));
        bankReserve -= lendAmt;
    }

    function repayLoan() external payable {
        uint amount = msg.value;
        customers[msg.sender].lendAmount += amount;
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
        customers[msg.sender].accountBal -= amount;
        customers[destination].accountBal += amount;
    }
}
