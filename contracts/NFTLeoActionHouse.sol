pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";



contract NFTActionHouse is Ownable {
  using SafeMath for uint256;

  mapping(address => mapping(uint256 => address)) public ownerOfToken;
  mapping(address => mapping(uint256 => uint256)) public priceOfToken;
  mapping(address => uint256) public userBalance;

  event Nftadd(address _nftContract, uint256 _nft, uint256 _price, address _user);
  event Nftedit(address _nftContract, uint256 _nft, uint256 _price, address _user);
  event Nftremove(address _nftContract, uint256 _nft, address _user);
  event Nftsold(address _nftContract, uint256 _nft, uint256 _price, address _user);


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
      _nftContract.transferFrom(address(this), msg.sender, _nft);
      delete ownerOfToken[address(_nftContract)][_nft];
      delete priceOfToken[address(_nftContract)][_nft];
      emit Nftremove(_nftContract, _nft, msg.sender);
  }


  function buyNFT(ERC721 _nftContract, uint256 _nft) external payable {
    require(ownerOfToken[_nftContract][_nft] != address(0) && ownerOfToken[_nftContract][_nft] != msg.sender);
    require(msg.value == priceOfToken[_nftContract][_nft]);
    _nftContract.transferFrom(address(this), msg.sender, _nft);
    emit Nftsold(_nftContract, _nft, priceOfToken[address(_nftContract)][_nft], msg.sender);
    address seller = ownerOfToken[address(_nftContract)][_nft];
    userBalance[seller] = userBalance[seller].add(msg.value);
    delete ownerOfToken[address(_nftContract)][_nft];
  }



  function withdrawFunds() external {
    uint256 balance = userBalance[msg.sender];
    require(balance > 0);
    //require(address(this).balance >= balance);
    userBalance[msg.sender] = 0;
    msg.sender.transfer(balance);
    emit Userwithdraw(msg.sender,balance);
  }
}
