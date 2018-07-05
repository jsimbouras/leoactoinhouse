pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";



contract NFTActionHouse is Ownable {
  using SafeMath for uint256;


  constructor() public {

  }

  function addNFT(ERC721 _nftContract, uint256 _nft, uint256 _price) external{
    } 

  modifier isUserAllowed(address _nftContract, uint256 _nft){
    
    _;
    }

  function editNFT(address _nftContract, uint256 _nft, uint256 _price) external isUserAllowed(_nftContract, _nft) {
    }

  function removeNFT(ERC721 _nftContract, uint256 _nft) external isUserAllowed(_nftContract, _nft) {
    }


  function buyNFT(ERC721 _nftContract, uint256 _nft) external payable {
    }



  function withdrawFunds() external {
  
    }

}
