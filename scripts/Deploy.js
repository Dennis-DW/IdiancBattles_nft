// Import the ethers library and Hardhat Runtime Environment (hre)
const { ethers } = require("hardhat");

// Define an async function for deployment
const main = async () => {
  try {
    // Get the contract factory for the "IdiancBattles" contract
    const nftContractFactory = await ethers.getContractFactory("IdiancBattles");

    // Deploy the contract
    const nftContract = await nftContractFactory.deploy();

    // Wait for the contract to be deployed
    await nftContract.deployed();

    // Log the contract address after deployment
    console.log("Contract deployed to:", nftContract.address);

    // Exit the process with success status (code 0)
    process.exit(0);
  } catch (error) {
    // Log any errors that occur during deployment
    console.log(error);

    // Exit the process with failure status (code 1)
    process.exit(1);
  }
};

// Execute the main function
main();
