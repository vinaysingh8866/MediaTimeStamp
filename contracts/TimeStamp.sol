// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title TimeStampHash
 * @dev 
 */

 contract TimeStampHash{

    struct Timestamp{
         uint totalStamps;
         mapping(bytes32 => bytes32) stamps;
    }

    struct ImageMeta{
        uint time;
        uint gps;
    }
    
    mapping(address => Timestamp) public data;
    mapping(bytes32 => address) public fileOwners;
    mapping(bytes32 => ImageMeta) public imageMetaData;


    function insertTimeStamp(bytes32 stampHash, bytes32 nameHash) public {
        uint256 total = data[msg.sender].totalStamps;
        fileOwners[stampHash] = msg.sender;
        data[msg.sender].totalStamps = total + 1;
        data[msg.sender].stamps[nameHash] = stampHash;
    }

    function getTimeStamp(bytes32 nameHash) public view returns(bytes32 stampHash){
        return data[msg.sender].stamps[nameHash]; 
    }

    function insertMultiple(bytes32[] memory stampHash,bytes32[] memory nameHash) public {
        require(stampHash.length == nameHash.length);
        uint256 total = data[msg.sender].totalStamps;
        for(uint i =0; i<=stampHash.length; i++){
            fileOwners[stampHash[i]] = msg.sender;
            data[msg.sender].totalStamps = total + 1;
            data[msg.sender].stamps[nameHash[i]] = stampHash[i];
        }
    }

    function getOwner(bytes32 stampHash) public view returns(address owner){
        return fileOwners[stampHash];
    }

    function insertImageMeta(uint time, uint gps, bytes32 stampHash) public {
        fileOwners[stampHash] = msg.sender;
        imageMetaData[stampHash].time = time;
        imageMetaData[stampHash].gps = gps;
    }
}
