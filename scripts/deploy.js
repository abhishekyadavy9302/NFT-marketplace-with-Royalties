const { ethers } = require("hardhat");

async function main() {
  console.log("🚀 Starting deployment to Core Testnet 2...");
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("📝 Deploying contracts with account:", deployer.address);
  
  // Check account balance
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("💰 Account balance:", ethers.formatEther(balance), "ETH");
  
  if (balance < ethers.parseEther("0.1")) {
    console.warn("⚠️  Warning: Account balance is low. Make sure you have enough funds for deployment.");
  }
  
  try {
    // Deploy the Project contract (NFT Marketplace with Royalties)
    console.log("\n📦 Deploying Project contract...");
    const Project = await ethers.getContractFactory("Project");
    const project = await Project.deploy();
    
    // Wait for deployment
    await project.waitForDeployment();
    const contractAddress = await project.getAddress();
    
    console.log("✅ Project contract deployed successfully!");
    console.log("📍 Contract Address:", contractAddress);
    console.log("🔗 Transaction Hash:", project.deploymentTransaction().hash);
    
    // Wait for a few confirmations
    console.log("\n⏳ Waiting for confirmations...");
    await project.deploymentTransaction().wait(3);
    
    console.log("✅ Contract confirmed on blockchain!");
    
    // Display contract information
    console.log("\n📋 Contract Information:");
    console.log("================================");
    console.log("Contract Name: NFT Marketplace with Royalties");
    console.log("Symbol: NFTMP");
    console.log("Address:", contractAddress);
    console.log("Network: Core Testnet 2");
    console.log("Deployer:", deployer.address);
    console.log("Block Number:", await ethers.provider.getBlockNumber());
    
    // Display next steps
    console.log("\n🎉 Deployment completed successfully!");
    console.log("\n📚 Next Steps:");
    console.log("1. Verify your contract on the Core explorer");
    console.log("2. Test the core functions: mintNFT, listNFT, buyNFT");
    console.log("3. Set up your frontend to interact with the contract");
    console.log("4. Configure IPFS for metadata storage");
    
    console.log("\n🔧 Contract Functions Available:");
    console.log("- mintNFT(recipient, tokenURI, royaltyRecipient, royaltyPercentage)");
    console.log("- listNFT(tokenId, price)");
    console.log("- buyNFT(tokenId) [payable]");
    console.log("- cancelListing(tokenId)");
    console.log("- setMarketplaceFee(newFee) [owner only]");
    console.log("- withdraw() [owner only]");
    
    return {
      contractAddress,
      deployer: deployer.address,
      transactionHash: project.deploymentTransaction().hash
    };
    
  } catch (error) {
    console.error("❌ Deployment failed:", error.message);
    
    if (error.message.includes("insufficient funds")) {
      console.log("\n💡 Solution: Add more funds to your deployer account");
      console.log("   Core Testnet 2 Faucet: Check Core blockchain documentation for testnet faucets");
    } else if (error.message.includes("nonce")) {
      console.log("\n💡 Solution: Wait a moment and try again, or reset your MetaMask account");
    } else if (error.message.includes("network")) {
      console.log("\n💡 Solution: Check your network configuration and RPC URL");
    }
    
    process.exit(1);
  }
}

// Execute deployment
main()
  .then((result) => {
    console.log("\n🎊 All done! Contract is ready to use.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("💥 Unexpected error:", error);
    process.exit(1);
  });
