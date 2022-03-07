// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "base64-sol/base64.sol";
import "./MerkleTree.sol";

contract CyrinoNFT is ERC721URIStorage, MerkleTree {
    // This variable will be used as the token id.
    // Inside the constructor tokenCounter is initialized with the value 0.
    // And is incremented every time a new NFT is minted.
    uint256 private tokenCounter;

    // This variable will be used to save the collection owner address
    // to create a require inside mint function.
    address private collectionOwner;

    constructor() MerkleTree() ERC721("Cyrino NFT", "cyNFT") {
        collectionOwner = msg.sender;
        tokenCounter = 0;
    }

    // This function is responsable to mint a new NFT.
    // You need to pass an address that will be the owner of the nft minted
    function mint(address ownerAddress) public {
        // This guarantees that only the collection owner can mint a new NFT.
        require(
            msg.sender == collectionOwner,
            "Only the collection owner can give mint nft's."
        );

        // Here we call a function of ERC721URIStorage to mint the nft
        // passing the owner address received and the tokenid which, in this case,
        // is represented by tokenCounter
        _safeMint(ownerAddress, tokenCounter);

        // Generates tokenURI
        string memory tokenURI = getTokenURI();

        // Finnaly the tokenURI is setted to our token
        _setTokenURI(tokenCounter, tokenURI);

        // This function call is responsable for saving the transaction
        // info on a leaf of the markle tree
        addNode(msg.sender, ownerAddress, tokenCounter, tokenURI);

        //incrementer for tokenId
        tokenCounter = tokenCounter + 1;
    }

    // This function returns the URI containing a name and a description
    function getTokenURI()
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "Cyrino NFT", "description": "A NFT!"}'
                            )
                        )
                    )
                )
            );
    }

    // This function only returns the address of the ownoer of a nft
    function getOwner(uint256 tokenId) public view returns (address owner) {
        owner = ownerOf(tokenId);
        return owner;
    }

    function getCollectionOwner() public view returns (address) {
        return collectionOwner;
    }
}
