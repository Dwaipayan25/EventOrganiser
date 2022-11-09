//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;
contract EventContract{
    address public contractManager;
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
        address[] participants;
    }
    constructor(){
        contractManager=msg.sender;
    }
    function contractBalance()public view returns(uint){
        return(address(this).balance);
    }
    mapping(uint=>Event)public events;
    mapping(uint=> address[])public _participants;
    uint counter=0;
    function organise(string memory _name,uint _price,uint _ticketCount)public{
        events[counter].organizer=msg.sender;
        events[counter].name=_name;
        events[counter].price=_price*(10**18);
        events[counter].date=block.timestamp;
        events[counter].ticketCount=_ticketCount;
        events[counter].ticketRemain=_ticketCount;
        counter++;
    }
    function buy(uint eventNumber)public payable{ 
        require(counter>0,"No events with this number is started");
        require(events[eventNumber].ticketRemain>0,"All tickets are sold");
        require(msg.sender.balance>=events[eventNumber].price,"Not enough balance in account");
        require(msg.value==events[eventNumber].price,"Not enough funds");
        //uint funds=msg.value*90/100;
        payable(events[eventNumber].organizer).transfer(msg.value*90/100);
        _participants[eventNumber].push(msg.sender);
        events[eventNumber].participants.push(msg.sender);
        events[eventNumber].ticketRemain--;
    }
    function getMoney()public{
        require(msg.sender==contractManager,"Only contract manager can call this");
        payable(contractManager).transfer(address(this).balance);
    }
    function endEvent(uint eventNo)public {
        require(msg.sender==events[eventNo].organizer,"Only event organiser can end events");
        delete events[eventNo];
    }
}