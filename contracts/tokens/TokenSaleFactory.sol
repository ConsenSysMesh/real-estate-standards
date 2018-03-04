pragma solidity 0.4.15;

import "./TokenSale.sol";
import "./AssetToken.sol";


/**
 * @title Token Sale contract Factory
 *
 * @dev Implementation of the Token sale contract factory.
 * @dev Based on code: https://github.com/OpenZeppelin/token-marketplace/blob/master/contracts/TokenSaleFactory.sol
 */
contract TokenSaleFactory {
  
  event TokenSaleCreated(address tokenSaleAddress);

  function TokenSaleFactory() public {}

  function createTokenSale(AssetToken _token, uint256 _price) external returns (address) {
    require(_price > 0);

    TokenSale tokenSale = new TokenSale(_token, _price);
    tokenSale.transferOwnership(msg.sender);
    TokenSaleCreated(tokenSale);

    return tokenSale;
  }
}
