// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


interface mintNftEvent{

    event MintNftEvent(address indexed from, address indexed to, uint256 indexed tokenId, string tokenURI);
}

contract NFT is ERC721URIStorage, AccessControl, mintNftEvent {

    
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    bytes32 public constant MINTER_NFT_TRANSFER_ROLE = keccak256("MINTER_NFT_TRANSFER_ROLE");
    
    bool private _nftTransferEnable;

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    constructor() ERC721("Meta Fantasy", "MF")  {
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
         _setupRole(MINTER_ROLE, msg.sender);
         _setupRole(MINTER_NFT_TRANSFER_ROLE, msg.sender);
         _nftTransferEnable = true;
    }

    
    function mintNft(address to, uint256 _tokenId, string memory tokenURI) public{
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, _tokenId);
        _setTokenURI(_tokenId, tokenURI);
        emit MintNftEvent(_msgSender(), to, _tokenId, tokenURI);
    }

    
    function mintNftBatch(address[] memory to, uint256[] memory _tokenId, string[] memory tokenURI) public{
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
        uint _tokenIdLength = _tokenId.length;
        for (uint i = 0; i < _tokenIdLength; i++) {
            _mint(to[i], _tokenId[i]);
            _setTokenURI(_tokenId[i], tokenURI[i]);
            emit MintNftEvent(_msgSender(), to[i], _tokenId[i], tokenURI[i]);
        }
    }

    function setNftTransferEnable(bool _enable) public{
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
        _nftTransferEnable = _enable;
    }

    function getNftTransferEnable() public view returns(bool){
        return _nftTransferEnable;
    }

    
    function _existsNftTransferEnable()internal view virtual returns (bool){
        if(_nftTransferEnable ){
            if(hasRole(MINTER_NFT_TRANSFER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender)){
                return true;
            }
            return false;
        }
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_existsNftTransferEnable(), "transfer is not a minter");
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(_existsNftTransferEnable(), "transfer is not a minter");
        super.safeTransferFrom(from, to, tokenId, "");
    }


    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_existsNftTransferEnable(), "transfer is not a minter");
        super.safeTransferFrom(from, to, tokenId, _data);
    }
}

