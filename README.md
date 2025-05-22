# NFT Marketplace with Royalties

A decentralized NFT marketplace built on Core Blockchain that enables creators to mint, list, and trade NFTs while automatically distributing royalties to original creators on every secondary sale.

## Project Description

This project implements a comprehensive NFT marketplace smart contract that combines ERC-721 token functionality with an integrated trading platform. The marketplace supports automatic royalty distribution following the EIP-2981 standard, ensuring creators receive compensation from secondary sales. Built with security and efficiency in mind, the contract uses OpenZeppelin's battle-tested libraries and includes features like reentrancy protection, access control, and escrow functionality.

The smart contract serves as both an NFT collection and a marketplace, streamlining the process for users who want to mint and immediately list their digital assets for sale. The integrated approach reduces gas costs and complexity while maintaining full decentralization.

## Project Vision

Our vision is to create a creator-first NFT ecosystem that prioritizes artist compensation and sustainable creative economies. We aim to democratize access to NFT creation and trading while ensuring that original creators continue to benefit from the appreciation of their work through automatic royalty payments.

By building on Core Blockchain, we leverage fast transaction speeds and low costs to make NFT trading accessible to creators and collectors of all levels. The platform envisions a future where digital art and collectibles can be traded freely while maintaining strong creator rights and transparent fee structures.

## Key Features

### Core Marketplace Functions
- **NFT Minting with Royalties**: Create new NFTs with customizable royalty percentages (up to 10%) that automatically apply to all future sales
- **Decentralized Listing System**: List NFTs for sale with automatic escrow functionality that secures assets during the sale process
- **Instant Purchase with Auto-Distribution**: Buy NFTs with automatic distribution of payments to sellers, creators (royalties), and platform (fees)

### Advanced Features
- **EIP-2981 Royalty Standard**: Full compliance with the royalty standard for maximum compatibility with other NFT platforms
- **Flexible Fee Structure**: Configurable marketplace fees (maximum 10%) that can be adjusted by contract owner
- **Listing Management**: Sellers can cancel listings and reclaim their NFTs at any time before sale
- **Security Measures**: Reentrancy protection, access controls, and safe transfer mechanisms
- **Gas Optimization**: Efficient contract design minimizing transaction costs for all operations

### Technical Specifications
- Built on Solidity 0.8.20 with latest security features
- Uses OpenZeppelin contracts for maximum security and compatibility
- Deployed on Core Testnet 2 for fast and cost-effective transactions
- Comprehensive event logging for frontend integration and analytics
- Supports metadata storage via IPFS or other URI-based systems

## Future Scope

### Phase 1: Enhanced Trading Features
- **Auction System**: Implement English and Dutch auction mechanisms for price discovery
- **Offer System**: Allow buyers to make offers below listing price with acceptance/rejection functionality
- **Bundle Trading**: Enable selling multiple NFTs as collections or bundles
- **Reserved Listings**: Allow sellers to reserve NFTs for specific buyers

### Phase 2: Advanced Marketplace Features
- **Multi-Payment Token Support**: Accept payments in various ERC-20 tokens beyond native currency
- **Fractional Ownership**: Enable fractional NFT ownership through ERC-1155 or custom mechanisms
- **Rental System**: Implement NFT rental functionality for gaming and utility NFTs
- **Cross-Chain Bridge**: Enable trading across multiple blockchain networks

### Phase 3: Community and Governance
- **DAO Governance**: Transition to community-governed marketplace with voting mechanisms
- **Creator Verification**: Implement verification system for authentic creators and collections
- **Reputation System**: Build reputation scores for buyers and sellers based on trading history
- **Community Rewards**: Distribute platform tokens to active users and creators

### Phase 4: Integration and Expansion
- **Mobile Application**: Develop mobile apps for iOS and Android with full marketplace functionality
- **AR/VR Integration**: Support for augmented and virtual reality NFT experiences
- **Gaming Integration**: Specialized features for gaming NFTs including in-game utility
- **Enterprise Solutions**: White-label marketplace solutions for businesses and organizations

### Technical Roadmap
- **Layer 2 Integration**: Implement Layer 2 solutions for even lower transaction costs
- **IPFS Integration**: Direct IPFS integration for decentralized metadata storage
- **Analytics Dashboard**: Comprehensive analytics for creators, collectors, and marketplace metrics
- **API Development**: RESTful APIs for third-party integrations and data access

## Installation and Setup

### Prerequisites
- Node.js (v16 or higher)
- npm or yarn
- MetaMask or compatible Web3 wallet

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nft-marketplace-with-royalties
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   ```bash
   cp .env.example .env
   # Edit .env file with your private key and RPC URL
   ```

4. **Compile contracts**
   ```bash
   npm run compile
   ```

5. **Deploy to Core Testnet 2**
   ```bash
   npm run deploy
   ```

### Core Functions Usage

#### Minting NFTs
```solidity
mintNFT(
    recipient,        // Address to receive the NFT
    tokenURI,         // IPFS or HTTP URL for metadata
    royaltyRecipient, // Address to receive royalties
    royaltyPercentage // Percentage in basis points (500 = 5%)
)
```

#### Listing for Sale
```solidity
listNFT(tokenId, priceInWei)
```

#### Purchasing NFTs
```solidity
buyNFT(tokenId) // Send ETH equal to or greater than listing price
```

## Contract Architecture

The Project.sol contract inherits from multiple OpenZeppelin contracts:
- `ERC721`: Core NFT functionality
- `ERC721URIStorage`: Metadata URI management
- `IERC2981`: Royalty standard interface
- `Ownable`: Access control for administrative functions
- `ReentrancyGuard`: Protection against reentrancy attacks

## Contributing

We welcome contributions from the community! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For technical support, feature requests, or general questions:
- Create an issue in the GitHub repository
- Join our Discord community
- Follow us on Twitter for updates

## Acknowledgments

- OpenZeppelin for secure smart contract libraries
- Core Blockchain for fast and efficient infrastructure
- The NFT and DeFi communities for inspiration and standards
