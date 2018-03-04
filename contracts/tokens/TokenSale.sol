pragma solidity 0.4.15;

import "./AssetToken.sol";
import "./Ownable.sol";


/**
 * @title Token Sale contract
 *
 * @dev Implementation of the Token sale contract.
 * @dev Based on code: https://github.com/OpenZeppelin/token-marketplace/blob/master/contracts/TokenSale.sol
 */
contract TokenSale is Ownable {
  bool public closed;
  uint256 public priceInWei;
  AssetToken public token;

  event Refund(uint256 amount);
  event TokenPurchased(address buyer, address seller, uint256 price, uint256 amount);

  modifier notClosed() {
    require(!closed);
    _;
  }

  modifier hasSomeTokens() {
    require(amount() > 0);
    _;
  }

  function TokenSale(AssetToken _token, uint256 _price) public {
    if (_price < 0) revert();

    token = _token;
    priceInWei = _price;
    closed = false;
  }

  function () public payable notClosed hasSomeTokens {
    require(msg.value == priceInWei);

    closed = true;

    uint256 _amount = amount();
    address _buyer = msg.sender;
    if (!token.transfer(_buyer, _amount)) revert();
    owner.transfer(priceInWei);
    TokenPurchased(_buyer, owner, priceInWei, _amount);
  }

  function amount() public constant returns(uint256) {
    return token.balanceOf(this);
  }

  function refund() public onlyOwner notClosed hasSomeTokens returns(bool) {
    closed = true;

    uint256 _amount = amount();
    if (!token.transfer(owner, _amount)) revert();
    Refund(_amount);
    return true;
  }
}
