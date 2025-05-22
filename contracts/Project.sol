// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @title NFT Marketplace with Royalties
 * @dev A decentralized marketplace for trading NFTs with built-in royalty support
 */
contract Project is ERC721, ERC721URIStorage, IERC2981, Ownable, ReentrancyGuard {
    
    // Counter for token IDs
    uint256 private _tokenIdCounter = 1;
    
    // Marketplace fee percentage (in basis points, e.g., 250 = 2.5%)
    uint256 public marketplaceFee = 250;
    
    // Maximum royalty percentage (10%)
    uint256 public constant MAX_ROYALTY_PERCENTAGE = 1000;
    
    // Struct to store listing information
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
    }
    
    // Struct to store royalty information
    struct RoyaltyInfo {
        address recipient;
        uint96 percentage; // in basis points (e.g., 500 = 5%)
    }
    
    // Mappings
    mapping(uint256 => Listing) public listings;
    mapping(uint256 => RoyaltyInfo) private _royalties;
    
    // Events
    event NFTMinted(uint256 indexed tokenId, address indexed creator, string tokenURI);
    event NFTListed(uint256 indexed tokenId, address indexed seller, uint256 price);
    event NFTSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);
    event ListingCancelled(uint256 indexed tokenId, address indexed seller);
    event RoyaltySet(uint256 indexed tokenId, address indexed recipient, uint96 percentage);
    
    constructor() ERC721("NFT Marketplace", "NFTMP") Ownable(msg.sender) {}
    
    /**
     * @dev Core Function 1: Mint NFT with royalty information
     * @param recipient Address to receive the NFT
     * @param tokenURI Metadata URI for the NFT
     * @param royaltyRecipient Address to receive royalties
     * @param royaltyPercentage Royalty percentage in basis points
     */
    function mintNFT(
        address recipient,
        string memory tokenURI,
        address royaltyRecipient,
        uint96 royaltyPercentage
    ) public returns (uint256) {
        require(royaltyPercentage <= MAX_ROYALTY_PERCENTAGE, "Royalty percentage too high");
        require(royaltyRecipient != address(0), "Invalid royalty recipient");
        
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        // Set royalty information
        _royalties[tokenId] = RoyaltyInfo(royaltyRecipient, royaltyPercentage);
        
        emit NFTMinted(tokenId, recipient, tokenURI);
        emit RoyaltySet(tokenId, royaltyRecipient, royaltyPercentage);
        
        return tokenId;
    }
    
    /**
     * @dev Core Function 2: List NFT for sale
     * @param tokenId ID of the NFT to list
     * @param price Price in wei
     */
    function listNFT(uint256 tokenId, uint256 price) public {
        require(_ownerOf(tokenId) == msg.sender, "Only owner can list NFT");
        require(price > 0, "Price must be greater than 0");
        require(!listings[tokenId].active, "NFT already listed");
        
        // Transfer NFT to contract for escrow
        _transfer(msg.sender, address(this), tokenId);
        
        listings[tokenId] = Listing({
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            active: true
        });
        
        emit NFTListed(tokenId, msg.sender, price);
    }
    
    /**
     * @dev Core Function 3: Buy NFT with automatic royalty distribution
     * @param tokenId ID of the NFT to purchase
     */
    function buyNFT(uint256 tokenId) public payable nonReentrant {
        Listing storage listing = listings[tokenId];
        require(listing.active, "NFT not listed for sale");
        require(msg.value >= listing.price, "Insufficient payment");
        
        address seller = listing.seller;
        uint256 price = listing.price;
        
        // Mark listing as inactive
        listing.active = false;
        
        // Calculate fees and royalties
        uint256 marketplaceFeeAmount = (price * marketplaceFee) / 10000;
        uint256 royaltyAmount = 0;
        address royaltyRecipient = address(0);
        
        // Get royalty information
        RoyaltyInfo memory royaltyInfo = _royalties[tokenId];
        if (royaltyInfo.recipient != address(0) && royaltyInfo.percentage > 0) {
            royaltyAmount = (price * royaltyInfo.percentage) / 10000;
            royaltyRecipient = royaltyInfo.recipient;
        }
        
        uint256 sellerAmount = price - marketplaceFeeAmount - royaltyAmount;
        
        // Transfer NFT to buyer
        _transfer(address(this), msg.sender, tokenId);
        
        // Distribute payments
        if (marketplaceFeeAmount > 0) {
            payable(owner()).transfer(marketplaceFeeAmount);
        }
        
        if (royaltyAmount > 0 && royaltyRecipient != address(0)) {
            payable(royaltyRecipient).transfer(royaltyAmount);
        }
        
        payable(seller).transfer(sellerAmount);
        
        // Refund excess payment
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
        
        emit NFTSold(tokenId, msg.sender, seller, price);
    }
    
    /**
     * @dev Cancel listing and return NFT to seller
     * @param tokenId ID of the NFT to cancel listing
     */
    function cancelListing(uint256 tokenId) public {
        Listing storage listing = listings[tokenId];
        require(listing.active, "NFT not listed");
        require(listing.seller == msg.sender, "Only seller can cancel");
        
        listing.active = false;
        
        // Return NFT to seller
        _transfer(address(this), msg.sender, tokenId);
        
        emit ListingCancelled(tokenId, msg.sender);
    }
    
    /**
     * @dev Get royalty information for a token (EIP-2981)
     * @param tokenId ID of the NFT
     * @param salePrice Sale price to calculate royalty for
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice)
        external
        view
        override
        returns (address, uint256)
    {
        RoyaltyInfo memory royalty = _royalties[tokenId];
        uint256 royaltyAmount = (salePrice * royalty.percentage) / 10000;
        return (royalty.recipient, royaltyAmount);
    }
    
    /**
     * @dev Set marketplace fee (only owner)
     * @param newFee New fee percentage in basis points
     */
    function setMarketplaceFee(uint256 newFee) public onlyOwner {
        require(newFee <= 1000, "Fee cannot exceed 10%");
        marketplaceFee = newFee;
    }
    
    /**
     * @dev Get current token counter
     */
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIdCounter;
    }
    
    /**
     * @dev Check if contract supports an interface
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, IERC165)
        returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
    
    /**
     * @dev Override tokenURI function
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    /**
     * @dev Withdraw contract balance (only owner)
     */
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }
}
