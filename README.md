# Smart Contracts
The following specification describes standard attributes and functions for storing the unique identity for a spatial unit on an Ethereum network. The spatial unit could represent any physical place: real estate property, land areas, borders, public property, air rights, etc. The content is based on the work done on OpenStreetMap as well as past ERC’s like identities (ERC 725) and claims (ERC 735).

This spatial unit identity should reference a volumetric area on Earth, have a simply alias, and hash that uniquely defines it. Based on this skeleton identity, many different types of metadata, relationships, and rights could be assigned to it including ownership, occupancy, tenancy, etc. This universally unique identifier is meant to be a community-sourced standard used to connect the multitude of existing real estate and geospatial datasets.

## Motivation
A common standard is needed for the multitude of systems, dapps, and smart contracts that reference a unique location on earth. Ownership and other rights can be claimed on the property, and media links (URIs) can be added to the property referencing external resources (data sets, IPFS hash, websites, crypto-spatial-coordinates, etc.).

## SpatialUnit
### Fields
* alias
* geohash

### Functions
* execute - call a function or send a transaction as the property identity (ie pay utility bill).
* approve - conditions that must be met to execute a call.
* editAlias
* editSpatial

## SpatialUnitRegistry
Adapt `contracts/PropertyRegistry` to become a SpatialUnitRegistry that stores all SpatialUnits that have been created.

## MetadataRegistry
The purpose of the MetadataRegistry is for anyone to upload a link to metadata/images/etc that's associated with a particular SpatialUnit. The SpatialUnit contract contains very little information about the specific location, but someone could link to a JSON object on IPFS that gives more detail or to the SpatialUnit's specific link on OpenStreetMap.

The MetadataRegistry should be adapted from `contracts/ClaimsRegistry` aka uPort's ERC780 (https://github.com/ethereum/EIPs/issues/780).

In addition, the 'values' in the registry should be links to external data sources. Taking from ERC721's tokenMetadata functionality, we should explore using a multiaddr (https://github.com/multiformats/multiaddr) to represent data on IPFS or anywhere reachable via HTTP(s).

## RightsRegistry
The RightsRegistry will connect a user/group to a property and specify the types of rights the user has on the property including ownership, tenancy, right to farm, etc. The RightsRegistry seeks evolve the notion of ownership defined in ERC20 and ERC721 to encompass any type of right that an individual or group has to an asset.

### Fields
* RightsHolderEntity (address)
* RightsType (Owns, leases, can farm, etc.)
* RightsContract (address) - Specifies the terms of the rights
* TargetEntity (SpatialUnit address)
* Status (Active, Pending, Deprecated)
* startBlock
* validUntil (optional) - expiration block

### Methods
* Add new entry
* Read entry
* Return all the keys to the map
* Set status of entry
