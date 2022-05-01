// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0; 

contract HelloWorld {
    uint256 storeNumber;

    function _storeNumber (uint256 _num) public{
        storeNumber = _num;      
    }
    function retrieveNumber () public view returns (uint256) {
        return storeNumber;
    }
}
