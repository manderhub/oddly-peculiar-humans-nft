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

    // base SVC code string
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    
    // 2-dimensional array of 3 dynamic arrays
    string[][3] wordLibrary;

    function generatePseudoRandomIndex(string memory _input) private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _input)));
    }

    function generateRandomTriple(uint _input) private view returns (string memory) {
        string memory triple = "";
        for(uint i = 0; i < wordLibrary.length; i++) {
            string memory word = wordLibrary[i][generatePseudoRandomIndex(string(abi.encodePacked(triple, Strings.toString(_input)))) % wordLibrary[i].length];
            triple = string(abi.encodePacked(triple, word));
        }
        return triple;
    }

    // ERC721 ("SquareNFT", "SQUARE") "calls" the constructor or the parent contract ERC721
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        wordLibrary[0] = ["Abnormally","Abruptly","Absently","Accidentally","Accusingly","Actually","Adventurously","Adversely","Amazingly","Angrily","Anxiously","Arrogantly","Awkwardly","Badly","Bashfully"];
        wordLibrary[1] = ["Abundant","Accurate","Addicted","Adorable","Adventurous","Afraid","Aggressive","Alcoholic","Alert","Aloof","Ambitious","Ancient","Angry","Animated","Annoying"];
        wordLibrary[2] = ["Boris","Aleksandr","Igor","Nikita","Timofey","Vadim","Ilya","Jaroslav","Ruslan","Anastasia","Ekaterina","Alyona","Mila","Viktoria","Sasha","Inessa"];
    }

    // A function our user will hit from the front-end to get their NFT
    function makeAnEpicNFT() public {

        // Get the current tokenId, this starts at 0.
        // Used to keep track of the NFTs unique identifier.
        uint256 newItemId = _tokenIds.current();

        string memory tripleWord = generateRandomTriple(newItemId);
        string memory finalSvg = string(abi.encodePacked(baseSvg, tripleWord, "</text></svg>"));
        console.log("\n-------------------");
        console.log(finalSvg);
        console.log("\n-------------------");

        // Mint the NFT with id newItemId to the user with address msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs unique identifier along with the data associated w/ that unique identifier.
        _setTokenURI(newItemId, "PLACEHOLDER");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}