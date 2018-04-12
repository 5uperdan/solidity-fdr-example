pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

contract FlightDataRecords {
    
    struct NoFlyZone{
        bytes16[] lat;
        bytes16[] long;
        uint16[] altitude; // meters
        bytes16 startDate; // iso format: 2018-01-25T07:54:45Z
        bytes16 endDate; // iso format: 2018-01-25T07:54:45Z
    }

    struct Record {
        bytes16 lat;
        bytes16 long;
        uint16 altitude; // meters
        uint16 heading; // degrees
        uint8 speed; // m/s
        uint batterylevel; // %
        bytes16 dateTime; // iso format: 2018-01-25T07:54:45Z
    }
    
    event newRecord(
        address drone,
        bytes16 lat,
        bytes16 long,
        uint16 altitude,
        uint16 heading,
        uint8 speed,
        uint batterylevel,
        bytes16 datetime
    );
    
    mapping(address => Record[]) Records;
    
    uint NoFlyZoneCount;
    mapping(uint => NoFlyZone) NoFlyZones;

    function setRecord(address _address, bytes16 _lat, bytes16 _long, uint16 _altitude, uint16 _heading, uint8 _speed, uint _batterylevel, bytes16 _dateTime) public{
        require(msg.sender == _address);
        Records[_address].push(Record(_lat, _long, _altitude, _heading, _speed, _batterylevel, _dateTime));
        emit newRecord(msg.sender, _lat, _long, _altitude, _heading, _speed, _batterylevel, _dateTime);
    }
    
    function getRecord(address _address, uint _recordIndex) public constant returns (bytes16, bytes16, uint16, uint16, uint8, uint, bytes16){
        Record[] storage droneRecords = Records[_address];
        
        return (droneRecords[_recordIndex].lat, 
        droneRecords[_recordIndex].long, 
        droneRecords[_recordIndex].altitude, 
        droneRecords[_recordIndex].heading, 
        droneRecords[_recordIndex].speed, 
        droneRecords[_recordIndex].batterylevel, 
        droneRecords[_recordIndex].dateTime);
    }
    
    function getRecordCount(address _address) public constant returns (uint){
        return Records[_address].length;
    }
    
    function addNoFlyZone(NoFlyZone _noFlyZone) public{
        NoFlyZoneCount += 1;
        
        NoFlyZones[NoFlyZoneCount] = _noFlyZone;
    }
    
    function getNoFlyZone(uint _noFlyZoneIndex) public constant returns (NoFlyZone){
        return NoFlyZones[_noFlyZoneIndex];
    }
   
}
