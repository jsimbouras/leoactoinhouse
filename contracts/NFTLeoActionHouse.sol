pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";



contract NFTActionHouse is Ownable {
  using SafeMath for uint256;

  mapping(address => mapping(uint256 => address)) public ownerOfToken;
  mapping(address => mapping(uint256 => uint256)) public priceOfToken;

  event Nftadd(address _nftContract, uint256 _nft, uint256 _price, address _user);
  event Nftedit(address _nftContract, uint256 _nft, uint256 _price, address _user);


  constructor() public {

  }

  function addNFT(ERC721 _nftContract, uint256 _nft, uint256 _price) external{
      require(_nftContract.getApproved(_nft) == address(this));

      _nftContract.transferFrom(msg.sender, this, _nft);

      ownerOfToken[address(_nftContract)][_nft] = msg.sender;
      priceOfToken[address(_nftContract)][_nft] = _price;

      emit Nftadd(_nftContract, _nft, _price, msg.sender);


    } 

  modifier isUserAllowed(address _nftContract, uint256 _nft){
    require(ownerOfToken[_nftContract][_nft] == msg.sender);
    _;
  }

  function editNFT(address _nftContract, uint256 _nft, uint256 _price) external isUserAllowed(_nftContract, _nft) {
    require(priceOfToken[_nftContract][_nft] != _price, "this price is the same as old price");
    priceOfToken[_nftContract][_nft] = _price;
    emit Nftedit(_nftContract, _nft, _price, msg.sender);
  }

  function removeNFT(ERC721 _nftContract, uint256 _nft) external isUserAllowed(_nftContract, _nft) {
  }


  function buyNFT(ERC721 _nftContract, uint256 _nft) external payable {
  }



  function withdrawFunds() external {
  }




}
