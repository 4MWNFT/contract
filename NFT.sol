// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// 铸造事件
interface mintNftEvent{

    event MintNftEvent(address indexed from, address indexed to, uint256 indexed tokenId, string tokenURI);
}

contract NFT is ERC721URIStorage, AccessControl, mintNftEvent {

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Meta Fantasy  ==>  MF
    constructor() ERC721("Meta Fantasy", "MF")  {
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
         _setupRole(MINTER_ROLE, msg.sender);
    }

    // mint NFT
    function mintNft(address to, uint256 _tokenId, string memory tokenURI) public{
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, _tokenId);
        _setTokenURI(_tokenId, tokenURI);
        emit MintNftEvent(_msgSender(), to, _tokenId, tokenURI);
    }

    // batch mint NFT
    function mintNftBatch(address[] memory to, uint256[] memory _tokenId, string[] memory tokenURI) public{
        require(hasRole(MINTER_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not a minter");
        uint _tokenIdLength = _tokenId.length;
        for (uint i = 0; i < _tokenIdLength; i++) {
            _mint(to[i], _tokenId[i]);
            _setTokenURI(_tokenId[i], tokenURI[i]);
            emit MintNftEvent(_msgSender(), to[i], _tokenId[i], tokenURI[i]);
        }
    }
}

