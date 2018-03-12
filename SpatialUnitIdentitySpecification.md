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

An open identity standard for a location on Earth with associated linked metadata.

## Abstract

Abstract
This standard describes standard attributes and functions for storing the unique identity of a spatial unit on earth on an Ethereum network. The location can be any point, line, area, or volume, does not rely on a single geospatial format, and allows a simple alias to descibe the entry. This spatial unit identity (SUI) merges past work on identities (ERC 725) and claims (ERC 735) to create a universally unique identifier with a flexible schema to allow anyone to add metadata, documents, and media. The community-sourced standard can be used to connect and augment the multitude of existing geospatial and real estate datasets.

## Motivation

A common standard is needed for the multitude of dapps, systems, and smart contracts that reference a unique location on earth. A spatial unit could represent any physical place like a land area, geographic borders, real estate, AR locations, etc. and allow anyone to upload information including real estate listings, land deeds, restaurant reviews, etc. Other smart contracts can be linked to it including claims of ownership or tenancy ZZZZlinkZZZZ, tokens and NFTs for easy exchange, and external data sources like IPFS hashes, websites, OpenStreetMap IDs, etc. 

## Specification

SpatialUnit.sol

### Fields
1.	csc – Crypto spatial coordinates uniquely defining location and smart contract
2.	alias – Human readable title for the location
3.	spatialValue – The value of the spatial unit of format spatialType.
4.	spatialType – The type of geospatial description. ‘geohash’ in most cases.

https://github.com/multiformats/multiaddr

Functions

```
function alias() constant returns (string alias)
```

```
function csc() constant returns (string csc)
```

```
function setCsc()
```
Function to validate and set the csc after the contract is created. Can only be called once.

```
function execute()
```
Call a function or send a transaction as the property identity (ie pay utility bill).

```
function approve(address _to, uint256 _tokenId)
```

Grants approval for address `_to` to take possession of the NFT with ID `_tokenId`. This method MUST `throw` if `msg.sender != ownerOf(_tokenId)`, or if `_tokenID` does not represent an NFT currently tracked by this contract, or if `msg.sender == _to`.
Only one address can "have approval" at any given time; calling `approveTransfer` with a new address revokes approval for the previous address. Calling this method with 0 as the `_to` argument clears approval for any address.
Successful completion of this method MUST emit an `Approval` event (defined below) unless the caller is attempting to clear approval when there is no pending approval. In particular, an Approval event MUST be fired if the `_to` address is zero and there is some outstanding approval. Additionally, an Approval event MUST be fired if `_to` is already the currently approved address and this call otherwise has no effect. (i.e. An `approve()` call that "reaffirms" an existing approval MUST fire an event.)

```
function ownerOf(uint256 _tokenId) constant returns (address owner)
```

Returns the address currently marked as the owner of `_tokenID`. This method MUST `throw` if `_tokenID` does not represent an NFT currently tracked by this contract. This method MUST NOT return 0 (NFTs assigned to the zero address are considered destroyed, and queries about them should `throw`).

### approve

### Events





## Implementation

*TBD*

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).




```
function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl)
```

*OPTIONAL - It is recommend that this method is implemented for enhanced usability with wallets and exchanges, but interfaces and other contracts MUST NOT depend on the existence of this method.*
Returns a [multiaddress](https://github.com/multiformats/multiaddr) string referencing an external resource bundle that contains (optionally localized) metadata about the NFT associated with `_tokenId`. The string MUST be an IPFS or HTTP(S) base path (without a trailing slash) to which specific subpaths are obtained through concatenation. (IPFS is the preferred format due to better scalability, persistence, and immutability.)
Standard sub-paths:

* name (required) - The `name` sub-path MUST contain the UTF-8 encoded name of the specific NFT (i.e. distinct from the name of the collection, as returned by the contract's `name` method). A name SHOULD be 50 characters or less, and unique amongst all NFTs tracked by this contract. A name MAY contain white space characters, but MUST NOT include new-line or carriage-return characters. A name MAY include a numeric component to differentiate from similar NFTs in the same contract. For example: "Happy Token [#157](https://github.com/ethereum/EIPs/issues/157)".
* image (optional) - If the `image` sub-path exists, it MUST contain a PNG, JPEG, or SVG image with at least 300 pixels of detail in each dimension. The image aspect ratio SHOULD be between 16:9 (landscape mode) and 2:3 (portrait mode). The image SHOULD be structured with a "safe zone" such that cropping the image to a maximal, central square doesn't remove any critical information. (The easiest way to meet this requirement is simply to use a 1:1 image aspect ratio.)
* description (optional) - If the `description` sub-path exists, it MUST contain a UTF-8 encoded textual description of the asset. This description MAY contain multiple lines and SHOULD use a single new-line character to delimit explicit line-breaks, and two new-line characters to delimit paragraphs. The description MAY include [CommonMark](http://commonmark.org/)-compatible Markdown annotations for styling. The description SHOULD be 1500 characters or less.
* other metadata (optional) - A contract MAY choose to include any number of additional subpaths, where they are deemed useful. There may be future formal and informal standards for additional metadata fields independent of this standard.

Each metadata subpath (including subpaths not defined in this standard) MUST contain a sub-path `default` leading to a file containing the default (i.e. unlocalized) version of the data for that metadata element. For example, an NFT with the metadata path `/ipfs/QmZU8bKEG8fhcQwKoLHfjtJoKBzvUT5LFR3f8dEz86WdVe` MUST contain the NFT's name as a UTF-8 encoded string available at the full path `/ipfs/QmZU8bKEG8fhcQwKoLHfjtJoKBzvUT5LFR3f8dEz86WdVe/name/default`. Additionally, each metadata subpath MAY have one or more localizations at a subpath of an [ISO 639-1](https://en.wikipedia.org/wiki/ISO_639-1) language code (the same language codes used for HTML). For example, `/ipfs/QmZU8bKEG8fhcQwKoLHfjtJoKBzvUT5LFR3f8dEz86WdVe/name/en` would have the name in English, and `/ipfs/QmZU8bKEG8fhcQwKoLHfjtJoKBzvUT5LFR3f8dEz86WdVe/name/fr` would have the name in French (note that even localized values need to have a `default` entry). Consumers of NFT metadata SHOULD look for a localized value before falling back to the `default` value. Consumers MUST NOT assume that all metadata subpaths for a particular NFT are localized similarly. For example, it will be common for the `name` and `image` objects to not be localized even when the `description` is.
You can explore the metadata package referenced in this example [here](https://ipfs.io/ipfs/QmZU8bKEG8fhcQwKoLHfjtJoKBzvUT5LFR3f8dEz86WdVe).
