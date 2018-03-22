pragma solidity ^0.4.20;

contract SpatialUnit
{
    
    address owner;
    address receiver;
    string alias;
    string geohash;
    
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

contract MetadataRegistry is SpatialUnitRegistry
{
    mapping(address => mapping(address => mapping(bytes32 => bytes32))) metadata;
    
    event MetadataSet(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        bytes32 value,
        uint updatedAt);
        
    event MetadataRemoved(
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        uint removedAt);
    
    function setMetaData(address subject, bytes32 key, bytes32 value)
    public
    {
        metadata[msg.sender][subject][key] = value;
        emit MetadataSet(msg.sender, subject, key, value, now);
    }
    
    function getClaim(address issuer, address subject, bytes32 key)
    public
    constant
    returns (bytes32) 
    {
        return metadata[issuer][subject][key];
    }
    
    function removeMetadata(address issuer, address subject, bytes32 key)
    public
    {
        require(msg.sender == issuer || msg.sender == subject);
        delete metadata[issuer][subject][key];
        emit MetadataRemoved(msg.sender, subject, key, now);
    }
}


