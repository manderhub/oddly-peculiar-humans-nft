/*
    run locally with: npx hardhat run scripts/deploy.js --network rinkeby
*/
// constant variable main is of type async function
// behind main hides a lamda function which is async and has function body in between {}
// we can call this variable just like we call a function: main()
const main = async () => {
    // compile contract and generate necessary files (e.g. in artifacts/)
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    // deploys the contract to local blockchain
    const nftContract = await nftContractFactory.deploy();
    // wait until contract is successfully mined on local blockchain
    await nftContract.deployed();
    // output the address of our contract on the local blockchain
    console.log("Contract deployed to:", nftContract.address);

    /*
    // Call the function
    let txn = await nftContract.makeAnEpicNFT();
    // wait for it to be minted
    
    await txn.wait();
    console.log("Minted NFT #1")
    */

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