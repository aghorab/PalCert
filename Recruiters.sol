// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Admins.sol" ;

contract Recruiters {

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;

    struct Recruiter {
        uint256 registriation_date;
		uint8  status;   
		string 	json_hash; //  if no update permission
		string	json_url;
    }

    mapping(address => Recruiter) RecruitersList;

    constructor() {

    }

    function _recruiterRegistiration(address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));
		require(RecruitersList[_address].status != Request, "Recruiter already exists-Request");
		require(RecruitersList[_address].status != Pending, "Recruiter already exists-Pending");
		require(RecruitersList[_address].status != Approved, "Recruiter already exists-Approved");
		require(RecruitersList[_address].status != Suspended, "Recruiter already exists-Suspended");
		require(RecruitersList[_address].status == None, "Recruiter already exists");

		bool result = false;
		
		RecruitersList[_address].registriation_date = block.timestamp;
		RecruitersList[_address].status = Approved;
		RecruitersList[_address].json_hash = _json_hash;
		RecruitersList[_address].json_url = _json_url;
		result = true;
		
		return result;
		
	}
	
	function _recruiterStatus(address _address) public view returns (uint8) {
		require(_address != address(0));
		require(RecruitersList[_address].status != None, "Recruiter Not Found");
				
		return RecruitersList[_address].status;
		
	}
	
	function _recruiterPending(address _address) public returns (bool) {
		require(_address != address(0));		
		require(RecruitersList[_address].status != Pending, "Recruiter already Pending");
		require(RecruitersList[_address].status != Approved, "Recruiter already Approved");
		require(RecruitersList[_address].status != Suspended, "Recruiter already Suspended");
		require(RecruitersList[_address].status != None, "Recruiter Not Found");

		require(RecruitersList[_address].status == Request);
		
		bool result = false;		
		RecruitersList[_address].status = Pending;
		result = true;
		
		return result;
		
	}
	
	function _recruiterApproving(address _address) public returns (bool) {
		require(_address != address(0));
		//require(RecruitersList[_address].status != Request, "Recruiter already Pending");
		require(RecruitersList[_address].status != Approved, "Recruiter already Approved");
		//require(RecruitersList[_address].status != Suspended, "Recruiter already Suspended");
		require(RecruitersList[_address].status != None, "Recruiter Not Found");

		//require(RecruitersList[_address].status == Pending);

		bool result = false;		
		RecruitersList[_address].status = Approved;
		result = true;
		
		return result;
		
	}
	
	function _recruiterSuspending(address _address) public returns (bool) {
		require(_address != address(0));
		require(RecruitersList[_address].status != Suspended, "Recruiter already Suspended");
		require(RecruitersList[_address].status != None, "Recruiter Not Found");

		bool result = false;
		RecruitersList[_address].status = Suspended;
		result = true;
		
		return result;
		
	}

}