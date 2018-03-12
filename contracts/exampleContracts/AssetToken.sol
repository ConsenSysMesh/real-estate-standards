pragma solidity 0.4.15;

import "./Whitelist.sol";
import "./MintableToken.sol";
import "./BurnableToken.sol";


contract AssetToken is MintableToken, BurnableToken {
  /*----------- Globals -----------*/

  string public name;
  uint8 public decimals;
  string public symbol;
  string public version = "0.2";
  Whitelist public whitelist;
  uint public investorCap;
  uint public currentInvestors;

  /*----------- Events -----------*/
  event LogChangeWhitelist(address sender, address whitelistAddress);

  /*----------- Modifier -----------*/
  modifier onlyWhitelist(address recipient) {
    require(whitelist.isWhitelisted(recipient));
    _;
  }

  modifier allowedByInvestorCap(address _to) {
    if (balances[_to] == 0) {
      require(currentInvestors < investorCap);
    }
    _;
  }

  /*----------- Constructor -----------*/
  function AssetToken(
    uint256 _initialAmount,
    string _name,
    uint8 _decimalUnits,
    string _symbol,
    address _whitelist,
    uint _investorCap
  ) 
    public 
  {
    investorCap = _investorCap;
    balances[msg.sender] = _initialAmount;
    currentInvestors = 1;
    totalSupply = _initialAmount;
    name = _name;
    decimals = _decimalUnits;
    symbol = _symbol;
    whitelist = Whitelist(_whitelist);
  }

  /*----------- Owner Methods -----------*/
  /**
   * @dev Change the address of the whitelist contract
   * @param _whitelist address The new address used to find the whitelist
   */
  function changeWhitelist(address _whitelist)
    public
    onlyOwner
    returns (bool success)
  {
    require(_whitelist != address(0));

    whitelist = Whitelist(_whitelist);
    return true;
  }

  /**
   * @dev Change the maximum allowable investors
   * @param _investorCap new maximum investor count
   */
  function changeInvestorCapTo(uint _investorCap)
    public
    onlyOwner
    returns (bool success)
  {
    require(_investorCap >= currentInvestors);
    investorCap = _investorCap;
    return true;
  }

  /**
   * @dev Change the name
   * @param _name new string for the name 
   */
  function changeName(string _name) 
    public
    onlyOwner
    returns( bool success )
  {
    name = _name;
    return true;
  }

  /**
    * @dev Change the decimalUnits
    * @param _decimalUnits new uint8 for controlling the decimal units
    */
  function changeDecimalUnits(uint8 _decimalUnits) 
    public
    onlyOwner
    returns( bool success )
  {
    decimals = _decimalUnits;
    return true;
  }

  /**
    * @dev Change the token symbol
    * @param _symbol new string for the symbol 
    */
  function changeSymbol(string _symbol) 
    public
    onlyOwner
    returns( bool success )
  {
    symbol = _symbol;
    return true;
  }

  /*----------- Whitelisted Methods -----------*/
  /**
   * @dev Transfer tokens from sender's address to another
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transfer(address _to, uint256 _value) 
    public 
    onlyWhitelist(_to)
    allowedByInvestorCap(_to)
    returns (bool success) 
  {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    updateInvestorCount(_to, msg.sender);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) 
    public 
    onlyWhitelist(_to)
    allowedByInvestorCap(_to)
    returns (bool success) 
  {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    updateInvestorCount(_to, _from);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  function mint(address _to, uint256 _amount) 
    public 
    onlyOwner
    onlyWhitelist(_to)
    allowedByInvestorCap(_to)
    returns (bool) 
  {
    totalSupply = totalSupply.add(_amount);
    if (balances[_to] == 0) { 
      currentInvestors = currentInvestors.add(1);
    }
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(0x0, _to, _amount);
    return true;
  }

  /**
   * @dev Burns a specific amount of tokens.
   * @param _amount The amount of token to be burned.
   */
  function burn(uint256 _amount) 
    public 
    onlyOwner 
  {
    require(_amount > 0);
    require(_amount <= balances[msg.sender]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_amount);
    if (balances[burner] == 0) { 
      currentInvestors = currentInvestors.sub(1);
    }
    totalSupply = totalSupply.sub(_amount);
    Burn(burner, _amount);
  }
  
  /*----------- Constant Methods -----------*/
  function getWhitelist()
    public
    constant
    returns(address whitelistAddress)
  {
    return whitelist;
  }

  function getOpenInvestorCount()
    public
    constant
    returns(uint unfilled)
  {
    return investorCap - currentInvestors;
  }

  /*----------- Internal Methods -----------*/
  function updateInvestorCount(address _to, address _from) 
    internal 
  {
    if (balances[_to] == 0) { 
      currentInvestors = currentInvestors.add(1);
    }
    if (balances[_from] == 0) { 
      currentInvestors = currentInvestors.sub(1);
    }
  }
}