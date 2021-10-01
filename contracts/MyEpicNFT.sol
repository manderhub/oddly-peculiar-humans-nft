// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libraries/Base64.sol";
import "./resources/Words.sol";

contract MyEpicNFT is ERC721URIStorage, Words {

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
    constructor() ERC721 ("PeculiarNFT", "PECULIAR") {
        wordLibrary[0] = adverbs;
        wordLibrary[1] = adjectives;
        wordLibrary[2] = names;
    }

    // A function our user will hit from the front-end to get their NFT
    function makeAnEpicNFT() public {

        // Get the current tokenId, this starts at 0.
        // Used to keep track of the NFTs unique identifier.
        uint256 newItemId = _tokenIds.current();

        string memory tripleWord = generateRandomTriple(newItemId);
        string memory finalSvg = string(abi.encodePacked(baseSvg, tripleWord, "</text></svg>"));

        // Get all the JSON metadata in place and base64 encode it
        string memory jsonEncoded = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // Set the title of the NFT as the generated word.
                        tripleWord,
                        '", "description": "Oddly peculiar humans.", "image": "data:image/svg+xml;base64,',
                        // append the base64 encoded svg
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Prepend data:application/json;base64 to our data
        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", jsonEncoded));

        console.log("\n-------------------");
        console.log(finalTokenUri);
        console.log("-------------------\n");

        // Mint the NFT with id newItemId to the user with address msg.sender.
        _safeMint(msg.sender, newItemId);

        // Set the NFTs unique identifier along with the data associated w/ that unique identifier.
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }
}