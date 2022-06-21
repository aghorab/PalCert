// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Admins {

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;
    
	struct Admin {
        uint256 registriation_date;
		uint8 status;        
		string 	json_hash; //  if no update permission
		string	json_url;
    }

	mapping(address => Admin) public AdminsList;    

	constructor(address _address) {
		require(_address != address(0), "Creator cannot be 0x00");
		AdminsList[_address].registriation_date = block.timestamp;
		AdminsList[_address].status = Approved;
    }

    function _adminAdd(address _sender, address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(AdminsList[_sender].status == Approved, "No permissions");
		require(_address != address(0), "No admin found");
		
		require(AdminsList[_address].status != Request, "Admin already exists-Request");
		require(AdminsList[_address].status != Pending, "Admin already exists-Pending");
		require(AdminsList[_address].status != Approved, "Admin already exists-Approved");
		require(AdminsList[_address].status != Suspended, "Admin already exists-Suspended");

		bool result = false;
		AdminsList[_address].registriation_date = block.timestamp;
		AdminsList[_address].status = Approved;
		AdminsList[_address].json_hash = _json_hash;
		AdminsList[_address].json_url = _json_url;
		result = true;
		
		return result;
		
	}
	
	function _adminStatus(address _sender, address _address) public view returns (uint8) {
		require(AdminsList[_sender].status == Approved, "No permissions");
		require(_address != address(0), "Address cannot be 0x00");
		require(AdminsList[_address].status != None, "Admin Not Found");
				
		return AdminsList[_address].status;
		
	}
	
	function _adminApproving(address _sender, address _address) public returns (bool) {
		require(AdminsList[_sender].status == Approved, "No permissions");
		require(_address != address(0), "No admin found");
		require(AdminsList[_address].status != Approved, "Admin already approved");
		require(AdminsList[_address].status != None, "Admin Not Found");
				
		bool result = false;
		AdminsList[_address].status = Approved;
		result = true;
		
		return result;
		
	}
	
	function _adminSuspending(address _sender, address _address) public returns (bool) {
		require(AdminsList[_sender].status == Approved, "No permissions");
		require(_address != address(0), "No admin found");
		require(AdminsList[_address].status != Suspended, "Admin already suspended");
		require(AdminsList[_address].status != None, "Admin Not Found");
				
		bool result = false;
		AdminsList[_address].status = Suspended;
		result = true;
		
		return result;
		
	}
}
