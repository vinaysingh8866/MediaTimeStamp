// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @author Shweta, Suyash, Tarandeep, Vinay
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
        string gps;
    }
    
    mapping(address => Timestamp) public data;
    mapping(bytes32 => address) public fileOwners;
    mapping(bytes32 => ImageMeta) public imageMetaData;

    /**
    * This method is used to insert store hashed file data and hashed filename.
    * @param stampHash byte32 hash of the data
    * @param nameHash byte32 hashed filename
    * 
    */
    function insertTimeStamp(bytes32 stampHash, bytes32 nameHash) public {
        uint256 total = data[msg.sender].totalStamps;
        fileOwners[stampHash] = msg.sender;
        data[msg.sender].totalStamps = total + 1;
        data[msg.sender].stamps[nameHash] = stampHash;
    }

    /**
    * Returns the hashed file data of the called for the passed hashed filename.
    * @param nameHash byte32 hashed file name.
    * @return stampHash hash of file data
    */

    function getTimeStamp(bytes32 nameHash) public view returns(bytes32 stampHash){
        return data[msg.sender].stamps[nameHash]; 
    }

    /**
    * This method is used to store multiple hashed data passed in the function
    * @param stampHash byte32 array of hashed data
    * @param nameHash byte32 array of hashed file's name.
    * 
    */
    function insertMultiple(bytes32[] memory stampHash,bytes32[] memory nameHash) public {
        require(stampHash.length == nameHash.length, "Array Length Mis-match");
        uint256 total = data[msg.sender].totalStamps;
        for(uint i =0; i<stampHash.length; i++){
            fileOwners[stampHash[i]] = msg.sender;
            data[msg.sender].totalStamps = total + 1;
            data[msg.sender].stamps[nameHash[i]] = stampHash[i];
        }
    }

    /**
    * Returns the owner's address of the hashed data.
    *
    * @param stampHash byte32 hash of data 
    * @return owner of hashed data
     */
    function getOwner(bytes32 stampHash) public view returns(address owner){
        return fileOwners[stampHash];
    }

    /**
    * This method is used to gather the hashed data of an image along with the location and time.
    * @param gps uint value of gps coordinates
    */    
    function insertImageMeta(string memory gps, bytes32 stampHash) public {
        fileOwners[stampHash] = msg.sender;
        imageMetaData[stampHash].time = block.timestamp;
        imageMetaData[stampHash].gps = gps;
    }

    /**
    * Returns the location and time of the uploaded image.
    *
    * @param stampHash hash of data  
    * @return imageMeta time and location of photo
    */
    function getImageMeta(bytes32 stampHash) public view returns(ImageMeta memory imageMeta){
        return imageMetaData[stampHash];
    }
}
