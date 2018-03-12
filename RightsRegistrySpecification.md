# Rights Registry Specification

## Preamble

```
`EIP: <to be assigned>
Title: Rights Registry Standard
Author: Corbin Page <corbin.page@consensys.net>
Type: Standard
Category: ERC
Status: Draft
Created: 2017-03-10`
```

## Simple Summary

A rights registry on privileges one entity has on another.

For example, tenancy is an expiring right between a individual and property. The rights are summarized in a smart contract deployed onchain via OpenLaw. It's a simple document summarizing the rights between the individual and property.

* Rights in the lease can expire
* Ability to challenge a specific term of the lease
** For example, if pets or smoking terms are violated
* How to handle groups leasing or renting?
** Some contract ID? Does uPort handle this?
* Rental terms and payment periods
** Should the rent go through this rights contract?
* Security deposit functionality / escrow
* Late rental payment markup
* Utility costs

# Influences
[Social Tenure Domain Model ](https://stdm.gltn.net/)

![Social Tenure Domain Model ](https://stdm.gltn.net/wp-content/uploads/2017/07/asAModeln112New2.jpg)