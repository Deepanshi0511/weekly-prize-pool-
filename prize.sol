
pragma solidity ^0.8.0;

contract WeeklyPrizePool {
    address public owner;
    uint256 public prizePool;
    uint256 public lastPayout;
    uint256 public payoutInterval = 7 days;
    mapping(address => uint256) public balances;
    address[] public participants;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        lastPayout = block.timestamp;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        prizePool += msg.value;
        if (balances[msg.sender] == 0) {
            participants.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
    }

    function distributePrize() public onlyOwner {
        require(block.timestamp >= lastPayout + payoutInterval, "Payout interval not reached");
        require(participants.length > 0, "No participants available");
        
        address winner = participants[block.timestamp % participants.length];
        uint256 prizeAmount = prizePool;
        prizePool = 0;
        lastPayout = block.timestamp;
        payable(winner).transfer(prizeAmount);
    }
    
    function getParticipants() public view returns (address[] memory) {
        return participants;
    }
}


