// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Admins.sol" ;

contract Graduates {

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;
	
    struct Graduate {
        uint256 registriation_date;
		uint8  status;
		string	graduate_id;
		string 	json_hash; //  if no update permission
		string	json_url;
    }

    mapping(address => Graduate) GraduatesList;

    constructor() {

    }

    function _graduateRegistiration(address _address,string memory _graduate_id, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));		
		require(GraduatesList[_address].status != Request, "Graduate already exists-Request");
		require(GraduatesList[_address].status != Pending, "Graduate already exists-Pending");
		require(GraduatesList[_address].status != Approved, "Graduate already exists-Approved");
		require(GraduatesList[_address].status != Suspended, "Graduate already exists-Suspended");
		require(GraduatesList[_address].status == None, "Graduate already exists" );

		bool result = false;
		
		GraduatesList[_address].registriation_date = block.timestamp;
		GraduatesList[_address].status = Request;
		GraduatesList[_address].graduate_id = _graduate_id;
		GraduatesList[_address].json_hash = _json_hash;
		GraduatesList[_address].json_url = _json_url;
		result = true;
		
		return result;
		
	}
	
	function _graduateStatus(address _address) public view returns (uint8) {
		require(_address != address(0));
		require(GraduatesList[_address].status != None, "Graduate Not Found");

		return GraduatesList[_address].status;
		
	}
	
	function _graduatePending(address _address) public returns (bool) {
		require(_address != address(0));	
		require(GraduatesList[_address].status != None, "Graduate Not Found" );	
		require(GraduatesList[_address].status != Pending, "Graduate already Pending");
		require(GraduatesList[_address].status != Approved, "Graduate already Approved");
		require(GraduatesList[_address].status != Suspended, "Graduate already Suspended");
		require(GraduatesList[_address].status != None, "Graduate Not Found");

		require(GraduatesList[_address].status == Request);
		
		bool result = false;		
		GraduatesList[_address].status = Pending;
		result = true;
		
		return result;
		
	}
	
	function _graduateApproving(address _address) public returns (bool) {
		//require(admins._adminStatus(msg.sender, msg.sender) == Approved);
		require(_address != address(0));
		require(GraduatesList[_address].status != None, "No Graduate Found");
		//require(GraduatesList[_address].status != Request, "Graduate already Request");
		require(GraduatesList[_address].status != Approved, "Graduate already Approved");
		//require(GraduatesList[_address].status != Suspended, "Graduate suspended");
		require(GraduatesList[_address].status != None, "Graduate Not Found");

		//require(GraduatesList[_address].status == Pending);

		bool result = false;		
		GraduatesList[_address].status = Approved;
		result = true;
		
		return result;
		
	}
	
	function _graduateSuspending(address _address) public returns (bool) {
		//require(admins._adminStatus(msg.sender, msg.sender) == Approved);
		require(_address != address(0));		
		require(GraduatesList[_address].status != Suspended, "Graduate already Suspended");
		require(GraduatesList[_address].status != None, "Graduate Not Found");
		bool result = false;
		GraduatesList[_address].status = Suspended;
		result = true;
		
		return result;
		
	}

}
