// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// foundation of our ERC721 Smart contract
import "@openzeppelin/contracts/utils/Counters.sol";
//  handling and storing our tokenIDs
import "@openzeppelin/contracts/utils/Strings.sol";
// implement the "toString()" function, that converts data into strings - sequences of characters
import "@openzeppelin/contracts/utils/Base64.sol";

// encoding our SVG to Base64-encoded data

// initialize our contract by inheriting the ERC721URIStorage and pass in the name and symbol of our NFT
contract IdiancBattles is ERC721URIStorage {
    // using the Counters library to create our tokenIDs
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // mapping to store the tokenURI of each NFT
    mapping(uint256 => uint256) public tokenIdToLevels;

    // event to be emitted when a new NFT is minted
    constructor() ERC721("Idianc Battles", "CBTLS") {}

    // function to generate the SVG of a specific NFT
    function generateCharacter(
        uint256 tokenId
    ) public view returns (string memory) {
        // incrementing the tokenID
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(tokenId),
            "</text>",
            "</svg>"
        );
        // storing the SVG in a string
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    // function to get the tokenURI of a specific NFT
    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }

    // function to get the tokenURI of a specific NFT
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Idianc Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on idianc",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );

        // console.log(
        //     "tokenId %s has levels %s",
        //     tokenId.toString(),
        //     getLevels(tokenId)
        // );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    // function to mint a new NFT
    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Token ID does not exist");
        require(
            ownerOf(tokenId) == msg.sender,
            "You are not the owner of this token can't train it"
        );
        uint256 currentLevel = tokenIdToLevels[tokenId];
        tokenIdToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
