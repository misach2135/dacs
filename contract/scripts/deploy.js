const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    
    console.log("Deploying contracts with the account:", deployer.address);
    
    // Deploy Classroom contract
    const Classroom = await ethers.getContractFactory("Classroom");
    const contract = await Classroom.deploy();
    
    await contract.waitForDeployment(); // Ensure deployment completes

    // Use contract.getAddress() instead of contract.target or contract.address
    const contractAddress = await contract.getAddress();

    console.log("Contract deployed at:", contractAddress);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
