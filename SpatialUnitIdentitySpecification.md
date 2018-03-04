# Spatial Unit Identity Specification

## Preamble

```
`EIP: <to be assigned>
Title: Spatial Unit Identity Standard
Author: Corbin Page <corbin.page@consensys.net>
Type: Standard
Category: ERC
Status: Draft
Created: 2017-03-10`
```

## Simple Summary

An identity standard for a location on Earth.

## Abstract

Abstract
This standard describes standard attributes and functions for storing the unique identity of a spatial unit on earth on an Ethereum network. This spatial unit identity (SUI) is fully flexible with many different types of metadata, relationships, and rights able to be assigned to it. This universally unique identifier is meant to be a community-sourced standard used to connect and augment the multitude of existing geospatial datasets.


The content is based on the work done on OpenStreetMap as well as past ERC’s like identities (ERC 725) and claims (ERC 735).

This spatial unit identity should reference a volumetric area on Earth, have a simply alias, and hash that uniquely defines it. 


## Motivation

A common standard is needed for the multitude of dapps, systems, and smart contracts that reference a unique location on earth. The spatial unit could represent any physical place like a land area, geographic borders, real estate, AR locations, etc. Other smart contracts can be linked to it including claims of ownership or tenancy ZZZZlinkZZZZ, tokens and NFTs for easy exchange, and external data sources like IPFS hashes, websites, OpenStreetMap IDs, etc.

## Specification

### ERC-20 Compatibility

### name



```
function name() constant returns (string name)
```

*OPTIONAL - It is recommend that this method is implemented for enhanced usability with wallets and exchanges, but interfaces and other contracts MUST NOT depend on the existence of this method.*
Returns the name of the collection of NFTs managed by this contract. - e.g. `"My Non-Fungibles"`.

### symbol



```
function symbol() constant returns (string symbol)
```

*OPTIONAL - It is recommend that this method is implemented for enhanced usability with wallets and exchanges, but interfaces and other contracts MUST NOT depend on the existence of this method.*
Returns a short string symbol referencing the entire collection of NFTs managed in this contract. e.g. "MNFT". This symbol SHOULD be short (3-8 characters is recommended), with no whitespace characters or new-lines and SHOULD be limited to the uppercase latin alphabet (i.e. the 26 letters used in English).

### totalSupply



```
function totalSupply() constant returns (uint256 totalSupply)
```

Returns the total number of NFTs currently tracked by this contract.

### balanceOf



```
function balanceOf(address _owner) constant returns (uint256 balance)
```

Returns the number of NFTs assigned to address `_owner`.

### Basic Ownership

### ownerOf



```
function ownerOf(uint256 _tokenId) constant returns (address owner)
```

Returns the address currently marked as the owner of `_tokenID`. This method MUST `throw` if `_tokenID` does not represent an NFT currently tracked by this contract. This method MUST NOT return 0 (NFTs assigned to the zero address are considered destroyed, and queries about them should `throw`).

### approve



```
function approve(address _to, uint256 _tokenId)
```

Grants approval for address `_to` to take possession of the NFT with ID `_tokenId`. This method MUST `throw` if `msg.sender != ownerOf(_tokenId)`, or if `_tokenID` does not represent an NFT currently tracked by this contract, or if `msg.sender == _to`.
Only one address can "have approval" at any given time; calling `approveTransfer` with a new address revokes approval for the previous address. Calling this method with 0 as the `_to` argument clears approval for any address.
Successful completion of this method MUST emit an `Approval` event (defined below) unless the caller is attempting to clear approval when there is no pending approval. In particular, an Approval event MUST be fired if the `_to` address is zero and there is some outstanding approval. Additionally, an Approval event MUST be fired if `_to` is already the currently approved address and this call otherwise has no effect. (i.e. An `approve()` call that "reaffirms" an existing approval MUST fire an event.)

|Action	|Prior State	|_to address	|New State	|Event	|
|---	|---	|---	|---	|---	|
|Clear unset approval	|Clear	|0	|Clear	|None	|
|Set new approval	|Clear	|X	|Set to X	|Approval(owner, X, tokenID)	|
|Change approval	|Set to X	|Y	|Set to Y	|Approval(owner, Y, tokenID)	|
|Reaffirm approval	|Set to X	|X	|Set to X	|Approval(owner, X, tokenID)	|
|Clear approval	|Set to X	|0	|Clear	|Approval(owner, 0, tokenID)	|

No