// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ballot{
    // variables 

struct vote{
    address voteraddress;
    bool choice;

}

struct voter{
    string voterName;
    bool voted;
}
uint private countResult = 0;
uint public finalResult = 0;
uint public totalVoter = 0;
uint public totalVote = 0;

address public ballotOfficialAddress;
string public ballotOfficialName;
string public proposal;

mapping(uint => vote) private votes;
mapping(address => voter) public voterRegister;

enum State {Created, Voting, Ended }
State public state;


    //Modifiers
modifier condition(bool _condition){
    require(_condition);
    _;
}

modifier onlyOfficial(){
    require(msg.sender== ballotOfficialAddress);
    _;
}

modifier inState(State _State){
require(state == _State);
_;
}
    //Functions
constructor(string memory _ballotOfficialName,string memory _proposal) public {
    ballotOfficialAddress = msg.sender;
    ballotOfficialName = _ballotOfficialName;
    proposal = _proposal;
    state = State.Created;

}

function addVoter(address _voterAddress,string memory _voterName) public inState(State.Created)onlyOfficial{
    voter memory V;
    V.voterName = _voterName;
    V.voted = false;
    voterRegister[_voterAddress] = V;
    totalVoter++;
    }

function startVote()public inState(State.Created) onlyOfficial{
    state = State.Voting;

}

function doVote(bool _choice)public inState(State.Voting) returns (bool voted){

bool isFound = false;
if(bytes(voterRegister[msg.sender].voterName).length != 0 && voterRegister[msg.sender].voted ==false)
{
voterRegister[msg.sender].voted = true;
vote memory v;
v.voteraddress = msg.sender;
v.choice = _choice;
if(_choice){
    countResult++;
}
votes[totalVote]=v;
totalVote++;
isFound = true;
} 
return isFound;
}

function endVote()public inState(State.Voting) onlyOfficial{
    state = State.Ended;
    finalResult = countResult;

}



}