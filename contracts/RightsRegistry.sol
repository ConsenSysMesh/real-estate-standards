pragma solidity ^0.4.20;

contract RightsRegistry {

    struct Right {
    	address holderEntity;
    	address targetEntity;
    	string rightsType;
    	address rightsContract;
    	string infoUrl;
    	unit status;
        uint startTime;
        uint expireTime;
    }

    Right[] rights;
    mapping(address => Right[]) indexedByHolderEntity;
    mapping(address => Right[]) indexedByRightsContract;

    function addRight(address targetEntity, address holderEntity, string rightsType) {
    	// Check that the rightsType for targetEntity isn't already taken

        uint len = rights.length;
        rights.length++;
        rights[len].holderEntity = holderEntity;
        rights[len].rightsType   = rightsType;

        uint olen = indexedByHolderEntity[holderEntity].length;
        indexedByHolderEntity[holderEntity].length++;
        indexedByHolderEntity[holderEntity][olen] = rights[len];
    }

    function getNumRights() returns (uint) {
        return rights.length;
    }

    function getRightAt(uint rightIndex) returns (
    	address holderEntity,
    	address targetEntity,
    	string rightsType,
    	address rightsContract,
    	string infoUrl,
    	unit status,
        uint startTime,
        uint expireTime,
    ) {
        holderEntity = rights[rightIndex].holderEntity;
        targetEntity = rights[rightIndex].targetEntity;
        rightsType = rights[rightIndex].rightsType;
        rightsContract = rights[rightIndex].rightsContract;
        infoUrl = rights[rightIndex].infoUrl;
        status = rights[rightIndex].status;
        startTime = rights[rightIndex].startTime;
        expireTime = rights[rightIndex].expireTime;
    }

}