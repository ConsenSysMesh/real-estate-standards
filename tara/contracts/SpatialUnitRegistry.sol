pragma solidity ^0.4.20;

contract SpatialUnit
{
    
    address public owner;
    address public receiver;
    string public alias;
    string public geohash;
    
    mapping(address => uint) paymentpool;
    
    function SpatialUnit(string _alias, string _geohash)
    public
    payable 
    {
        owner = msg.sender;
        alias = _alias;
        geohash = _geohash;
    }
    
    function () 
    public 
    payable 
    {
        // fallback function
    }
    
    function getBalance() 
    public 
    view
    returns (uint)
    {
        return address(this).balance;
    }
    
    function execPayment(address _receiver, uint _amount) 
    public 
    payable 
    onlyOwner 
    {
        // it is generally advisable to use pull OVER push for external calls (as per ConsenSys Security Best Practices repo)
        // _to = address to receive payment from SpatialUnit
        // _amount = amount of ether to send to ExecuteReceiver
        receiver = _receiver;
        require(_amount <= address(this).balance);
        paymentpool[receiver] += _amount;
        
        // address(_to).transfer(_amount);
    }
    
    function receivePayment() 
    external 
    {
        uint pmnt = paymentpool[msg.sender]; 
        paymentpool[msg.sender] = 0; 
        msg.sender.transfer(pmnt); 
    }
    
    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }
    
}

contract SpatialUnitRegistry
{
    address public owner;
    uint public numSpUnits;
    mapping(address => Unit) records;
    address[] public keys;
    
    // events
    event SpatialUnitAdded(address owner, string _alias, string _geoHash);
    
    // structs    
    struct Unit 
    {
        address owner;
        string alias;
        string geoHash; 
        uint keysIndex;
    }
    
    function SpatialUnitRegistry()
    public
    {
        owner = msg.sender;
    }
    
    function addSpatialUnit(string _alias, string _geoHash) 
    public 
    {
        address newSpatialUnit = new SpatialUnit(_alias, _geoHash);
        keys.push(newSpatialUnit);
        records[newSpatialUnit].alias = _alias;
        records[newSpatialUnit].geoHash = _geoHash;
        records[newSpatialUnit].owner = msg.sender;
        records[newSpatialUnit].keysIndex = keys.length;
        keys[keys.length - 1] = address(newSpatialUnit);
        numSpUnits++;
        emit SpatialUnitAdded(msg.sender, _alias, _geoHash);
    }
    
    function getSpatialUnit(address addr) 
    public
    view
    returns (address theowner, string alias, string geoHash) 
    {
        theowner = records[addr].owner;
        alias = records[addr].alias;
        geoHash = records[addr].geoHash;
    }
    
} 
