pragma solidity 0.4.15;

import "./AssetToken.sol";
import "./Ownable.sol";


/**
 * @title Token Purchase contract
 *
 * @dev Implementation of the Token purchase contract.
 * @dev Based on code: https://github.com/OpenZeppelin/token-marketplace/blob/master/contracts/TokenPurchase.sol
 */
contract TokenPurchase is Ownable {
  bool public closed;
  bool public canReceiveEther;
  uint256 public amount;
  AssetToken public token;

  event Refund(uint256 price);
  event TokenSold(address buyer, address seller, uint256 price, uint256 amount);

  modifier notClosed() {
    require(!closed);
    _;
  }

  modifier canNotReceiveEther() {
    require(!canReceiveEther);
    _;
  }

  function TokenPurchase(AssetToken _token, uint256 _amount) public {
    if (_amount <= 0) return;

    token = _token;
    amount = _amount;
    closed = true;
    canReceiveEther = true;
  }

  function () public payable onlyOwner {
    require(msg.value > 0);
    require(closed);
    require(canReceiveEther);

    closed = false;
    canReceiveEther = false;
  }

  function priceInWei() public constant returns(uint) {
    return this.balance;
  }

  function claim() public notClosed canNotReceiveEther returns(bool) {
    address _seller = msg.sender;
    uint256 _allowedTokens = token.allowance(_seller, address(this));
    require(_allowedTokens >= amount);

    closed = true;

    if (!token.transferFrom(_seller, owner, amount)) revert();
    uint256 _priceInWei = priceInWei();
    _seller.transfer(_priceInWei);
    TokenSold(owner, _seller, _priceInWei, amount);
    return true;
  }

  function refund() public onlyOwner notClosed canNotReceiveEther returns(bool) {
    closed = true;

    uint256 _priceInWei = priceInWei();
    owner.transfer(_priceInWei);
    Refund(_priceInWei);
    return true;
  }
}
