/*
    run locally with: npx hardhat run scripts/run.js
*/
const main = async () => {
    // compile contract and generate necessary files (e.g. in artifacts/)
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    // deploys the contract to local blockchain
    const nftContract = await nftContractFactory.deploy();
    // wait until contract is successfully mined on local blockchain
    await nftContract.deployed();
    // output the address of our contract on the local blockchain
    console.log("Contract deployed to:", nftContract.address);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();