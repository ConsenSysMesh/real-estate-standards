## Asset Token

This document defines a standard interface for asset token contracts.

<TO DO link to reference implementation>


## Abstract
----

Proposed below is an open standard for structuring the common fields for blockchain-based tokens representing the equity, debt, and other derivatives of individual real estate assets. If widely adopted, the open standard can be used to track the different instruments traded across multiple chains, aggregate transactions for all the similar products, and ease reporting and accounting functions. The standard is heavily based off the popular ERC20 standard as well as borrowing additional functionality from other ERCs.

## Motivation
---

This standard adopts the ERC20 and adds additional functions and fields to provide a means to represent tokenised assets.
The main advantages of the standard are:
- Conforms to existing standards such as the ERC20 and ERC223
- Is lightweight
-  

## Specification
----
AssetToken (TokenContract)

```

interface AssetToken {

    function name() public view returns(string);

    function symbol() public view returns(string);

    function totalSupply() public view returns(string);

    function decimals() public view returns (uint256);

    function assetAddress() public view returns (address);

    function balanceOf(address owner) public view returns (uint256 balance);

    function transfer(address to, uint value) public returns (bool ok);

    function transfer(address to, uint value, bytes data) public returns (bool ok);

    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);

    function approve(address spender, uint256 value) public returns (bool success);

    function transferFrom(address from, address to, uint256 value) public returns (bool success);

    function setMetadata(bytes data) public returns (bool success);

    function getMetaData() public view returns (bytes);

    function hasWhitelist() public view returns (bool);

}

```

The token-contracts MUST register the assetToken interface via ERC820.

The DEFAULT unit token IS 10^18.

----

### Parameters

#### 1) On-Chain Parameters

**name**

Represents the Human readable text describing the token - *e.g. “123 Trueman St - Unit 5 - Equity”*

>Of type `string`

**symbol**

Represents the symbol for the token - *e.g. “ESVTFB-USA-TM304”*
The symbol MUST conform to the following format:

- The first 5 characters have to represent the [Financial Instrument code](https://en.wikipedia.org/wiki/ISO_10962)
- The next 3 characters have to represent the [Country Code]( https://en.wikipedia.org/wiki/ISO_3166-2)
- The final 3-7 characters can be flexible; for instance a combination of street name, number, unit, debt/equity
- A hyphen must be used to separate each set of characters

>Of type `string`

**totalSupply**

Represents the total number of tokens issued wfor the given asset.

>Of type `uint256`

**decimals**

Represents the granularity i.e. it is the smallest part of the token that's not divisible.

Returns the smallest part of the token that's not divisible.

Any issue, transfer or redemption of tokens MUST be a multiple of this value. Any operation that would result in a balance that's not a multiple of this value, MUST be considered invalid and the transaction MUST throw.

*NOTE:* `decimals` MUST be greater or equal to 1

>Of type `uint256`

**assetAddress**

Represents the address of the smart contract that keeps custody of the asset or group of assets that the token holders have a right to.


>Of type `address`

**legalContractHash**

Represents the hash of the underlying legal agreement(s) that convey the right, obligations, prohibitions and permissions with repect to the asset and its counterparties.

The legal contract hash MUST be the`keccak256` hash of the legal contract that governs the asset.

>Of type `bytes32`

#### 2) Off chain parameters

Off chain paramters are of two categories:
1. Classification
2. Legal

These parameters are optional and depend on the asset being represented.

**Classification Parameters**


**assetClass**
Represents the asset class that the asset falls into. These could, but is not restricted to, include the following:

- equity
- interest rate
  - fixed income
  - debt
  - money market
- forex
- credit
- inflation
- commodity
  - metal (lme)
  - energy
  - agriculture/ soft commodities
  - precious metals
- real estate/ property
  - residential
  - commercial
- infrastructure
- collectibles
- hybrid
- cryto

>Of type `string`

**quotationCurrency**

Represents the currency against which the quotation for the asset is made.

It is not restricted to fiat and can be cryptocurrencies as well. This left to the discretion of the issuer of the asset token.

>Of type `string`

**issueDate**

Represents the date at which the asset was issued.

MUST be of the following format: *yyyy-mm-dd*

>Of type `string`

**ISIN or CUSIP no.**

These are unique numbers that represent the the instrument.

- The International Securities Identification Number (ISIN) is a code that uniquely identifies a specific securities issue.
- CUSIP refers to Committee on Uniform Security Identification Procedures and the nine-digit, alphanumeric CUSIP numbers that are used to identify securities, including municipal bonds. A CUSIP number, similar to a serial number, is assigned to each maturity of a municipal security issue

If used, it is up to the asset token entity to request these numbers from their respective bodies

The rationale to include this within the spec is based on the heavy reliance by the financial services industry for identification purposes.

>Of type `string`


**Legal Parameters**

**jurisdiction**

Represent the [Country Code]( https://en.wikipedia.org/wiki/ISO_3166-2) of the governing jurisdiction for the asset token and the jurisdiction in which any disputes that arise

>Of type `string`

**governingLaw**

Represents the legal body that the asset token uses. Any legal matters are resolved through this legal structure.

>Of type `string`

**language**

Represents the [ISO 639-2 code](https://www.loc.gov/standards/iso639-2/php/code_list.php) for the language in which the legal agreement is.

>Of type `string`


**smartContractAddress**

Represents the address of the smart contract that governs the rights, obligations, prohibitions and premissions of the token holders.

This can be used to automate some of the more mundane legal work flows, rather than representing them as legal mundane legal text.

>Of type `address`

---

### Functions

**getters**

All public parameters MUST have getters implemented (if not implicity done e.g. by Solidity).

 The body MUST mirror:

 `    function parameterName() public view returns(_type_);`

 Where the `_type_` is the type of the parameter as specified above.

 > Returns the value of the parameter; of type parameter

**transfer(address, uint)**

NOTE: An important point is that contract developers must implement `tokenFallback` if they want their contracts to work with the specified tokens.

If the receiver does not implement the tokenFallback function, consider the contract is not designed to work with tokens, then the transaction must fail and no tokens will be transferred. An analogy with an Ether transaction that is failing when trying to send Ether to a contract that did not implement `function() payable`.

`function transfer(address to, uint value) returns (bool)`

Needed due to backwards compatibility reasons because of ERC20 transfer function doesn't have bytes parameter. This function must transfer tokens and invoke the function `tokenFallback(address, uint256, bytes)` in `to`, if `to` is a contract. If the `tokenFallback` function is not implemented in `to` (receiver contract), then the transaction must fail and the transfer of tokens should not occur.



`function transfer(address to, uint value, bytes data) returns (bool)``

function that is always called when someone wants to transfer tokens.
This function must transfer tokens and invoke the function `tokenFallback (address, uint256, bytes)` in `to`, if `to` is a contract. If the `tokenFallback` function is not implemented in `to` (receiver contract), then the transaction must fail and the transfer of tokens should not occur.
If `to` is an externally owned address, then the transaction must be sent without trying to execute `tokenFallback` in `to`.
`data` can be attached to this token transaction and it will stay in blockchain forever (requires more gas). `data` can be empty.

NOTE: The recommended way to check whether the `to` is a contract or an address is to assemble the code of `to`. If there is no code in `to`, then this is an externally owned address, otherwise it's a contract.

**approve**
Allows `spender` to withdraw from your account multiple times, up to the `value` amount. If this function is called again it overwrites the current allowance with `value`.

**NOTE**:Based on [ERC20 approve](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)

**getMetaData**


**setMetaData**


**hasWhitelist**



## Rationale
---
`Motivate the need for the token and its design`


## Backwards Compatibility
---
>Based on ERC20 and ERC223

## Test Cases
---
`Link to tests`


## Implementation
`Link to reference implementation`


## Copyright

`Insert CC License or is it waived under CCO????`

---
