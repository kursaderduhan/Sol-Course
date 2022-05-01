// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0; 

contract Voting {
    struct voter {
        string voterName;
        bool isVoted;
    }
    struct Vote {
        address voterAddress;
        bool choice;
    }

    //Voting start time
    uint public startTime;

    uint private countResult;
    uint public finalResult;
    uint public totalVoter;
    uint public totalVote;

    address public votingAddress;
    string public votingName;
    string public proposal;

    mapping (uint => Vote) private votes;
    mapping (address => voter) public byVoter;

    enum State {
        Created,
        Voting,
        Ended
    }

    State public state;

    constructor(string memory _votingName, string memory _proposal) {
        votingAddress = msg.sender;
        votingName = _votingName;
        proposal = _proposal;
        state = State.Created;
    }
    function addVoter(address _voterAddress, string memory _voterName) public inState(State.Created) onlyOwner {
        voter memory v;
        v.voterName = _voterName;
        v.isVoted = false;
        byVoter[_voterAddress] = v;
        totalVoter++;
    }
    function startVote()public inState(State.Created) onlyOwner{
        state = State.Voting;
        startTime = block.timestamp;
    }
    function vote (bool _choice) public inState(State.Voting) voteEnded() returns(bool){
        bool found = false;
        if(bytes(byVoter[msg.sender].voterName).length != 0 && byVoter[msg.sender].isVoted)
        {
            byVoter[msg.sender].isVoted = true;
            Vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if(_choice){
                countResult++;
            }
            votes[totalVote] = v;
            totalVote++;
            found = true;
        }
        return found;
    }
     function endVote()public inState(State.Voting) onlyOwner{
        state = State.Ended;
        finalResult = countResult;
    }

    //Modifiers
    modifier inState(State _state) {
        require(state == _state);
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == votingAddress);
        _;
    }
    modifier condition(bool _condition) {
        require (_condition);
        _;
    }
    //Check Time
    modifier voteEnded() {
        require(block.timestamp < startTime+300, "Voting is finished");
        _;
    }
}