pragma solidity ^0.4.0;

contract PropertyRegistry {

    // Represents a transaction (buy/sell) on a property
    struct Transaction {
        uint time;
        address sellers;
        address buyer;
        string docIpfsHash;
    }
    
    struct Property {
        uint masterPlanId;
        uint propertyId; // this is the ID in the master plan, not here
        string deedIpfsHash;
        bool isConstructionDone;
        Transaction[] transactions;
        // Current owner is transactions[transactions.length - 1].buyer;
    }

    Property[] properties;
    mapping(address => Property[]) indexedByOwner;

    function addProperty(address owner, uint masterPlanId, uint propertyId) {
        // In real world system, only a set of pre-defined addresses will be able to 
        // call this function.
        uint len = properties.length;
        properties.length++;
        properties[len].masterPlanId = masterPlanId;
        properties[len].propertyId   = propertyId;

        uint tlen = properties[len].transactions.length;
        properties[len].transactions.length++;
        properties[len].transactions[tlen].buyer = owner;
        properties[len].transactions[tlen].time = now;

        uint olen = indexedByOwner[owner].length;
        indexedByOwner[owner].length++;
        indexedByOwner[owner][olen] = properties[len];
    }

    function addDeedIpfsHash(uint propertyIndex, string ipfsHash) {
        properties[propertyIndex].deedIpfsHash = ipfsHash;
    }

    function setConstructionDone(uint index) {
        properties[index].isConstructionDone = true;
    }

    function transferOwnership(uint propertyIndex, address newOwner, string docIpfsHash) {
        uint len = properties[propertyIndex].transactions.length;
        properties[propertyIndex].transactions.length++;
        address oldOwner = properties[propertyIndex].transactions[len].buyer;
        properties[propertyIndex].transactions[len].seller      = oldOwner;
        properties[propertyIndex].transactions[len].buyer       = newOwner;
        properties[propertyIndex].transactions[len].time        = now;
        properties[propertyIndex].transactions[len].docIpfsHash = docIpfsHash;
    }

    function getNumProperties() returns (uint) {
        return properties.length;
    }

    function getPropertyAt(uint propertyIndex) returns (
        uint masterPlanId,
        uint propertyId,
        string deedIpfsHash,
        address currentOwner
    ) {
        masterPlanId = properties[propertyIndex].masterPlanId;
        propertyId   = properties[propertyIndex].propertyId;
        deedIpfsHash = properties[propertyIndex].deedIpfsHash;
        uint len = properties[propertyIndex].transactions.length;
        currentOwner = properties[propertyIndex].transactions[len - 1].buyer;
    }

    function removeAllProperties() {
      // TODO: need to do proper cleanup here...
      properties.length = 0;
    }

}