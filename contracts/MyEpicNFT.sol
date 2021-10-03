// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    // Include functionality of the Counters contract from the @openzeppelin Library
    using Counters for Counters.Counter;
    // Counters.Counter is a struct, that can be incremented, decremented and reset
    Counters.Counter private _tokenIds;

    // base SVC code string
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: '#2D2424'; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    
    // 2-dimensional array of 3 dynamic arrays
    string[][3] wordLibrary;

    string[] colors = ["#DBD0C0", "#FAEEE0", "#F9E4C8", "#F9CF93", "#7D5A50","#B4846C","#E5B299","#FCDEC0","#493323","#91684A","#EAAC7F","#FFDF91","#F54748"];

    uint8 maxNumberNFT = 50;
    uint8 numberMintedNFT = 0;

    // Event to notify frontend about nft id
    event NewEpicNFTMinted(address sender, uint256 tokenId);

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

    function generateRandomColor(uint _input, string memory _word) private view returns (string memory) {
        return colors[generatePseudoRandomIndex(string(abi.encodePacked(_word, Strings.toString(_input)))) % colors.length];
    }

    // ERC721 ("SquareNFT", "SQUARE") "calls" the constructor or the parent contract ERC721
    constructor() ERC721 ("PeculiarNFT", "PECULIAR") {
        wordLibrary[0] = [
            "Awkwardly",
            "Blissfully",
            "Carelessly",
            "Deceivingly",
            "Elegantly",
            "Ferociously",
            "Greedily",
            "Hopelessly",
            "Intensely",
            "Jubilantly",
            "Knowingly",
            "Longingly",
            "Mortally",
            "Noisily",
            "Oddly",
            "Painfully",
            "Quizzically",
            "Recklessly",
            "Sheepishly",
            "Stubbornly",
            "Thoroughly",
            "Unbearably",
            "Violently",
            "Wildly",
            "Youthfully"
        ];
        wordLibrary[1] = [
            "Ancient",
            "Bizarre",
            "Damaged",
            "Damp",
            "Educated",
            "Foolish",
            "Glorious",
            "Humorous",
            "Innocent",
            "Juicy",
            "Kind",
            "Lonely",
            "Magical",
            "Naughty",
            "Obnoxious",
            "Peculiar",
            "Quiet",
            "Rude",
            "Selfish",
            "Thick",
            "Unique",
            "Vulgar",
            "Wise",
            "Young",
            "Zealous"
        ];
        wordLibrary[2] = [
            "Alexei",
            "Arkadi",
            "Boris",
            "Danil",
            "Eduard",
            "Fiodor",
            "Igor",
            "Leonid",
            "Maxim",
            "Nikita",
            "Oleg",
            "Pavel",
            "Stanislav",
            "Vadim",
            "Yuri",
            "Anastasia",
            "Evelina",
            "Galina",
            "Irina",
            "Ludmila",
            "Marina",
            "Olga",
            "Tatiana",
            "Viktoria",
            "Yelena"
        ];
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256) {
        return numberMintedNFT;
    }

    // A function our user will hit from the front-end to get their NFT
    function makeAnEpicNFT() public {
        require(numberMintedNFT <= maxNumberNFT, "No more NFTs left to be minted...");
        // Get the current tokenId, this starts at 0.
        // Used to keep track of the NFTs unique identifier.
        uint256 newItemId = _tokenIds.current();

        string memory tripleWord = generateRandomTriple(newItemId);
        string memory color = generateRandomColor(newItemId, tripleWord);
        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, tripleWord, "</text></svg>"));

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
        numberMintedNFT++;
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();

        // Emit an Event to the frontend
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}