// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyEpicNFT is ERC721URIStorage {

    // Include functionality of the Counters contract from the @openzeppelin Library
    using Counters for Counters.Counter;
    // Counters.Counter is a struct, that can be incremented, decremented and reset
    Counters.Counter private _tokenIds;

    // ERC721 ("SquareNFT", "SQUARE") "calls" the constructor or the parent contract ERC721
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("Bro, this NFT will be a banger!");
    }

    // A function our user will hit from the front-end to get their NFT
    function makeAnEpicNFT() public {

        // Get the current tokenId, this starts at 0.
        // Used to keep track of the NFTs unique identifier.
        uint256 newItemId = _tokenIds.current();

        // Mint the NFT with id newItemId to the user with address msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs unique identifier along with the data associated w/ that unique identifier.
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/P5VV");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}