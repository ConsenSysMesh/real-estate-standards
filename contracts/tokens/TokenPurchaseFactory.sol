pragma solidity 0.4.15;

import "./TokenPurchase.sol";
import "./AssetToken.sol";


/**
 * @title Token Purchase contract factory
 *
 * @dev Implementation of the Token purchase contract factory.
 * @dev Based on code: https://github.com/OpenZeppelin/token-marketplace/blob/master/contracts/TokenPurchaseFactory.sol
 */
contract TokenPurchaseFactory {

  event TokenPurchaseCreated(address tokenPurchaseAddress);

  function TokenPurchaseFactory() public {}

  function createTokenPurchase(AssetToken _token, uint256 _amount) external returns (address) {
    require(_amount > 0);

    TokenPurchase tokenPurchase = new TokenPurchase(_token, _amount);
    tokenPurchase.transferOwnership(msg.sender);
    TokenPurchaseCreated(tokenPurchase);

    return tokenPurchase;
  }
}
