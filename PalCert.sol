// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Admins.sol" ;
import "./Issuers.sol" ;
import "./Recruiters.sol" ;
import "./Graduates.sol" ;
import "./Certificates.sol" ;

contract PalCert {

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;

	address public owner;

	Admins admins;
	Issuers issuers;
	Recruiters recruiters;
	Graduates graduates;
	Certificates certificates;	
	
	constructor() {
        owner = msg.sender;
		admins = new Admins(msg.sender);
		issuers = new Issuers();
		recruiters = new Recruiters();
		graduates = new Graduates();
		certificates = new Certificates();
    }
	
	function adminAdd(address _sender, address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		return admins._adminAdd(_sender, _address, _json_hash, _json_url);
	}
	
	function adminStatus(address _sender, address _address) public view returns (uint8) {
		return admins._adminStatus(_sender, _address);
	}
	
	function adminApproving(address _sender, address _address) public returns (bool) {
		return admins._adminApproving(_sender, _address);		
	}
	
	function adminSuspending(address _sender, address _address) public returns (bool) {
		return admins._adminSuspending(_sender, _address);		
	}
	
	function issuerRegistiration(address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));
		
		return issuers._issuerRegistiration(_address, _json_hash, _json_url) ;
		
	}
	
	function issuerStatus(address _sender, address _address) public view returns (uint8) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
				
		return issuers._issuerStatus(_address);
		
	}
	
	function issuerPending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));		
		
		return issuers._issuerPending(_address);
		
	}
	
	function issuerApproving(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
		
		return issuers._issuerApproving(_address);
		
	}
	
	function issuerSuspending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
		
		return issuers._issuerSuspending(_address);
		
	}
	
	function recruiterRegistiration(address _address, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));

		return recruiters._recruiterRegistiration(_address, _json_hash, _json_url);
		
	}
	
	function recruiterStatus(address _sender, address _address) public view returns (uint8) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
				
		return recruiters._recruiterStatus(_address);
		
	}
	
	function recruiterPending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));		
		
		return recruiters._recruiterPending(_address);
		
	}
	
	function recruiterApproving(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));

		return recruiters._recruiterApproving(_address);
		
	}
	
	function recruiterSuspending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
	
		return recruiters._recruiterSuspending(_address);
		
	}
	
	function graduateRegistiration(address _address, string memory _graduate_id, string memory _json_hash, string memory _json_url) public returns (bool) {
		require(_address != address(0));

		return graduates._graduateRegistiration(_address, _graduate_id, _json_hash, _json_url);
		
	}
	
	function graduateStatus(address _sender, address _address) public view returns (uint8) {
		require(admins._adminStatus(_sender, _sender) == Approved, "No permissions");
		require(_address != address(0));
				
		return graduates._graduateStatus(_address);
		
	}
	
	function graduatePending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));		
		
		return graduates._graduatePending(_address);
		
	}
	
	function graduateApproving(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
		
		return graduates._graduateApproving(_address);
		
	}
	
	function graduateSuspending(address _sender, address _address) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		require(_address != address(0));
		
		return graduates._graduateSuspending(_address);
		
	}
	
	function certificateRegistiration( 	address _sender,
										string  memory _certificate_hash, 
										string  memory _certificate_url,		
										string  memory _json_hash, //  if no update permission
										string  memory _json_url,										
										address _graduate) public returns (bool) {
		
		require(issuers._issuerStatus(_sender) == Approved, "No permissions");
		require(_graduate != address(0), "Graduate not found");
		require(graduates._graduateStatus(_graduate) == Approved, "Graduate not Approved");
		
		return certificates._certificateRegistiration(  _sender,	
														_certificate_hash, 
														_certificate_url,		
														_json_hash, //  if no update permission
														_json_url,										
														_graduate);
		
	}
	
	function certificateStatus(address _sender, string memory _hash) public returns (uint8) {

        uint8 status;
		if( admins._adminStatus(_sender, _sender) == Approved ||
			issuers._issuerStatus(_sender) == Approved ||
			//recruiters._recruiterStatus(_sender) == Approved ||
			(graduates._graduateStatus(_sender) == Approved && certificates._certificateGraduate(_hash) == _sender)){
				
			status = certificates._certificateStatus(_hash);
		}
		
		return status; 
		
	}
	
	function certificateGet(address _sender, string memory _hash) public returns (Certificate memory) {

        Certificate memory certificate;
		if( admins._adminStatus(_sender, _sender) == Approved ||
			issuers._issuerStatus(_sender) == Approved ||
			//recruiters._recruiterStatus(_sender) == Approved ||
			(graduates._graduateStatus(_sender) == Approved && certificates._certificateGraduate(_hash) == _sender)){
				
			certificate = certificates._certificateGet(_hash);
		}
		
		return certificate;
		
	}
	
	function certificatePending(address _sender, string memory _hash) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		
		return certificates._certificatePending(_hash);
		
	}
	
	function certificateApproving(address _sender, string memory _hash, uint256 _expiration_date) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);

		return certificates._certificateApproving(_hash, _expiration_date);
		
	}
	
	function certificateSuspending(address _sender, string memory _hash) public returns (bool) {
		require(admins._adminStatus(_sender, _sender) == Approved);
		
		return certificates._certificateSuspending(_hash);
		
	}
	
}