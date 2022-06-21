// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Admins.sol" ;

contract Issuers {

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;

    struct Issuer {
        uint256 registriation_date;
		uint8  status;   
		string 	json_hash; //  if no update permission
		string	json_url;
    }

    mapping(address => Issuer) IssuersList;

    constructor() {

    }

    function _issuerRegistiration(address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));
		require(IssuersList[_address].status != Request, "Issuer already exists-Request");
		require(IssuersList[_address].status != Pending, "Issuer already exists-Pending");
		require(IssuersList[_address].status != Approved, "Issuer already exists-Approved");
		require(IssuersList[_address].status != Suspended, "Issuer already exists-Suspended");
		require(IssuersList[_address].status == None, "Issuer already exists");

		bool result = false;
		
		IssuersList[_address].registriation_date = block.timestamp;
		IssuersList[_address].status = Request;
		IssuersList[_address].json_hash = _json_hash;
		IssuersList[_address].json_url = _json_url;
		result = true;
		
		return result;
		
	}
	
	function _issuerStatus(address _address) public view returns (uint8) {
		require(_address != address(0));
		require(IssuersList[_address].status != None, "Issuer Not Found");
				
		return IssuersList[_address].status;
		
	}
	
	function _issuerPending(address _address) public returns (bool) {
		require(_address != address(0));		
		require(IssuersList[_address].status != Pending, "Issuer already Pending");
		require(IssuersList[_address].status != Approved, "Issuer already Approved");
		require(IssuersList[_address].status != Suspended, "Issuer already Suspended");
		require(IssuersList[_address].status != None, "Issuer Not Found");

		require(IssuersList[_address].status == Request);
		
		bool result = false;		
		IssuersList[_address].status = Pending;
		result = true;
		
		return result;
		
	}
	
	function _issuerApproving(address _address) public returns (bool) {
		require(_address != address(0));
		require(IssuersList[_address].status != Approved, "Issuer already Approved");
		require(IssuersList[_address].status != None, "Issuer Not Found");
		
		bool result = false;		
		IssuersList[_address].status = Approved;
		result = true;
		
		return result;
		
	}
	
	function _issuerSuspending(address _address) public returns (bool) {
		require(_address != address(0));
		require(IssuersList[_address].status != Suspended, "Issuer already Suspended");
		require(IssuersList[_address].status != None, "Issuer Not Found");
		
		bool result = false;
		IssuersList[_address].status = Suspended;
		result = true;
		
		return result;
		
	}

}
