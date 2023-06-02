// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./NFT.sol";

contract NFTMarketplace is NFT {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() {}

    struct theNFT {
        string name;
        string description;
        string metadataURI;
        bool listedForSale;
        uint256 salePrice;
    }
    uint256 marketplaceFeePercentage = 10;
    mapping(uint256 => theNFT) private _nfts;
    mapping(address => uint256) private ownerProfits;

    event NFTCreated(
        uint256 indexed tokenId,
        address indexed owner,
        string name,
        string description
    );
    event NFTListed(uint256 indexed tokenId, uint256 salePrice);
    event NFTSold(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 salePrice
    );

    function createNFT(string memory name, string memory description) external {
        uint256 newTokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, newTokenId);

        _nfts[newTokenId] = theNFT(name, description, "", false, 0);
        _tokenIdCounter.increment();

        emit NFTCreated(newTokenId, msg.sender, name, description);
    }

    function addMetadataURI(string memory metadata, uint256 tokenId) external {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: caller is not owner nor approved"
        );
        _nfts[tokenId].metadataURI = metadata;
    }

    function getMetadataURI(uint256 tokenId)
        external
        view
        returns (string memory)
    {
        require(_exists(tokenId), "ERC721: URI query for nonexistent token");
        return _nfts[tokenId].metadataURI;
    }

    function listNftForSale(uint256 tokenId, uint256 price) external {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC721: caller is not owner nor approved"
        );
        require(
            !_nfts[tokenId].listedForSale,
            "NFT is already listed for sale"
        );
        require(price > 0, "Price must be a valid number!");

        _nfts[tokenId].listedForSale = true;
        _nfts[tokenId].salePrice = price;
    }

    function buyNFT(uint256 tokenId) external payable {
        require(_exists(tokenId), "ERC721: URI query for nonexistent token");
        require(_nfts[tokenId].listedForSale == true, "NFT is not listed for sale!");
        address payable seller = payable(ownerOf(tokenId));
        address buyer = msg.sender;
        uint256 salePrice = _nfts[tokenId].salePrice;
        uint256 marketplaceFee = (salePrice * marketplaceFeePercentage) / 100;
        require(marketplaceFee > 0, "Fee must be a positive number!");
        ownerProfits[seller] += marketplaceFee;
        require(
            msg.value >= salePrice,
            "Price must be equal or more than the sale price!"
        );
        _nfts[tokenId].listedForSale = false;
        _nfts[tokenId].salePrice = 0;

        _transfer(seller, buyer, tokenId);

        seller.transfer(salePrice);

        emit NFTSold(tokenId, seller, buyer, salePrice);
    }
}
