pragma solidity ^0.4.23;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import 'openzeppelin-solidity/contracts/math/SafeMath.sol';

contract SampleNFT is ERC721Token, Ownable {
  using SafeMath for uint256;

  uint256 tokenIdCount = 1;

  constructor(string _name, string _symbol) ERC721Token(_name, _symbol) public {
  }

  function mint(address _beneficiary) public onlyOwner {
    _mint(_beneficiary, tokenIdCount);
    tokenIdCount = tokenIdCount.add(1);
  }
}
