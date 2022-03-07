// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MerkleTree {
    // Represents how many leafs the markle tree has
    uint256 private leafs = 16;
    // Hashs is an array containing every node of the markle tree
    bytes32[31] private hashs;
    // deafaultHash is the default hash value for empty leafs
    bytes32 private deafaultHash = keccak256(abi.encodePacked(""));
    // Root is the root hash of the tree
    bytes32 private root = deafaultHash;

    // this function populates the markle tree with the defaultHash
    constructor () {
        // First the hash of the default value is seted for every leaf
        for (uint256 i = 0; i < leafs; i++) {
            hashs[i] = deafaultHash;
        }
    }

    // checks if there is an empty leaf and returns its index if true
    function hasFreeSpace() private view returns (uint256) {
        // default value to represent an invalid index
        uint256 freeSpace = leafs * 2;

        // for each leaf we compare the hash with the defaultHash
        // if thats true, that leaf is empty
        for (uint256 i = 0; i < leafs; i++) {
            if (hashs[i] == deafaultHash) {
                // sets the index of the empty leaf
                freeSpace = i;
                break;
            }
        }

        return freeSpace;
    }

    // adds a new node to the tree and updates every needed hash
    function addNode(
        address sender,
        address owner,
        uint256 tokenId,
        string memory tokenURI
    ) internal {
        uint256 freeIndex = hasFreeSpace();

        // if freeIndex == leafs * 2, invalid index value, than there is no empty leaf
        require(freeIndex != leafs * 2, "There is no free space on the tree");

        hashs[freeIndex] = keccak256(
            abi.encodePacked(
                '{"owner": "',
                owner,
                '", "sender": "',
                sender,
                '", "tokenURI": "',
                tokenURI,
                '", "tokenId": "',
                tokenId,
                "}"
            )
        );

        // first left node to consider
        uint256 leftIndex = freeIndex % 2 == 0 ? freeIndex : freeIndex - 1;
        uint256 step = leftIndex / 2;
        uint256 lastIndex = 0;

        while (step >= 1) {
            // index of the node that must be changed
            uint256 index = leafs + (leftIndex / 2);

            // calculates the new hash using the new values
            bytes32 newHash = keccak256(
                abi.encodePacked(hashs[leftIndex], hashs[leftIndex + 1])
            );

            // save the new hash
            hashs[index] = newHash;

            // set the next interation left index based on the index just chuanged
            leftIndex = index % 2 == 0 ? index : index - 1;
            lastIndex = index;
            step /= 2;
        }

        root = hashs[lastIndex];
    }
}
