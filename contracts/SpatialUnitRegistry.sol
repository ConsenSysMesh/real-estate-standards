pragma solidity ^0.4.22;

contract SpatialUnit
{
    
    address public owner;
    address public receiver;
    string public alias;
    string public geohash;
    address[] public ownerhistory;
    
    mapping(address => uint) paymentpool;
	mapping(bytes32 => bytes32) keyvaluestore;
    
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

	function store(bytes32 _key, bytes32 _value)
	public
	returns (bytes32 _stored_val)
	{
		require(msg.sender == owner);
		keyvaluestore[_key] = _value;
		return _value;
	}

	function retrieve(bytes32 _key)
	public
	view 
	returns (bytes32 _stored_val)
	{
		return keyvaluestore[_key];
	}
    
    function execPayment(address _receiver, uint _amount) 
    public 
    payable 
    {
		require(msg.sender == owner);
        receiver = _receiver;
        require(_amount <= address(this).balance);
        paymentpool[receiver] += _amount;
    }
    
    function receivePayment() 
    external 
    {
        uint pmnt = paymentpool[msg.sender]; 
        paymentpool[msg.sender] = 0; 
        msg.sender.transfer(pmnt); 
    }
}

contract SpatialUnitRegistry
{
    address public owner;
    uint public numSpUnits;
    mapping(address => Unit) records;
    address[] public keys;
    
    // events
    event SpatialUnitAdded(address indexed owner, string indexed _alias, string indexed _geoHash);
    
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
	returns (address _newSpatialunit, uint _keyslength)
    {
        SpatialUnit newSpatialUnit = new SpatialUnit(_alias, _geoHash);
        keys.push(newSpatialUnit);
        records[newSpatialUnit].alias = _alias;
        records[newSpatialUnit].geoHash = _geoHash;
        records[newSpatialUnit].owner = msg.sender;
        records[newSpatialUnit].keysIndex = keys.length;
        keys[keys.length - 1] = address(newSpatialUnit);
        numSpUnits++;
        emit SpatialUnitAdded(newSpatialUnit, _alias, _geoHash);
		return(address(newSpatialUnit), keys.length);
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
