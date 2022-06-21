// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Admins.sol" ;

struct Certificate {
        uint256 registriation_date;
        uint256 expiration_date;
		uint8  status;   
		string 	certificate_hash; 
		string 	certificate_url;		
		string 	json_hash; //  if no update permission
		string	json_url;
		address	Issuer;
		address	graduate;
    }

contract Certificates {    

	uint8 None = 0; 
	uint8 Request = 1; 
	uint8 Pending = 2; 
	uint8 Approved = 3;
	uint8 Suspended = 4;

    mapping(string => Certificate) CertificatesList;

     constructor() {

    }

    function _certificateRegistiration( address _sender,
                                        string  memory _certificate_hash, 
										string  memory _certificate_url,		
										string  memory _json_hash, //  if no update permission
										string  memory _json_url,										
										address _graduate) public returns (bool) {
		
		//require(issuers._issuerStatus(_sender) == Approved);
		require(_graduate != address(0));
		//require(graduates._graduateStatus(_graduate) == Approved);
		require(CertificatesList[_json_hash].status != Request, "Certificate already exists-Request");
		require(CertificatesList[_json_hash].status != Pending, "Certificate already exists-Pending");
		require(CertificatesList[_json_hash].status != Approved, "Certificate already exists-Approved");
		require(CertificatesList[_json_hash].status != Suspended, "Certificate already exists-Suspended");
	
		bool result = false;
		
		CertificatesList[_json_hash].registriation_date = block.timestamp;
		CertificatesList[_json_hash].certificate_hash = _certificate_hash;
		CertificatesList[_json_hash].certificate_url = _certificate_url;
		CertificatesList[_json_hash].json_hash = _json_hash;
		CertificatesList[_json_hash].json_url = _json_url;
		CertificatesList[_json_hash].Issuer = _sender;
		CertificatesList[_json_hash].graduate = _graduate;
		CertificatesList[_json_hash].status = Request;
		result = true;
		
		return result;
		
	}
	
	function _certificateStatus(string memory _hash) public returns (uint8) {

		require(CertificatesList[_hash].status != None, "Certificate Not Found");
        uint8 status;
		/*if( admins._adminStatus(msg.sender, msg.sender) == Approved ||
			issuers._issuerStatus(msg.sender) == Approved ||
			recruiters._recruiterStatus(msg.sender) == Approved ||
			(graduates._graduateStatus(msg.sender) == Approved && Certificates[_hash].graduate == msg.sender)){
		*/
			if(CertificatesList[_hash].expiration_date < block.timestamp)
				 CertificatesList[_hash].status = Suspended;
				
			status = CertificatesList[_hash].status;
		//}
		
		return status;
		
	}

    function _certificateGraduate(string memory _hash) public returns (address) {

        address graduate;
		require(CertificatesList[_hash].status != None, "Certificate Not Found");
		/*if( admins._adminStatus(msg.sender, msg.sender) == Approved ||
			issuers._issuerStatus(msg.sender) == Approved ||
			recruiters._recruiterStatus(msg.sender) == Approved ||
			(graduates._graduateStatus(msg.sender) == Approved && Certificates[_hash].graduate == msg.sender)){
		*/
			if(CertificatesList[_hash].expiration_date < block.timestamp)
				 CertificatesList[_hash].status = Suspended;
				
			graduate = CertificatesList[_hash].graduate;
		//}
		
		return graduate;
		
	}
	
	function _certificateGet(string memory _hash) public returns (Certificate memory) {

        Certificate memory certificate;
		require(CertificatesList[_hash].status != None, "Certificate Not Found");
		/*if( admins._adminStatus(msg.sender, msg.sender) == Approved ||
			issuers._issuerStatus(msg.sender) == Approved ||
			recruiters._recruiterStatus(msg.sender) == Approved ||
			(graduates._graduateStatus(msg.sender) == Approved && CertificatesList[_hash].graduate == msg.sender)){
		*/
			if(CertificatesList[_hash].expiration_date < block.timestamp)
				 CertificatesList[_hash].status = Suspended;
				
			certificate = CertificatesList[_hash];
		//}
		
		return certificate;
		
	}
	
	function _certificatePending(string memory _hash) public returns (bool) {
		//require(admins._adminStatus(msg.sender, msg.sender) == Approved);
		require(CertificatesList[_hash].status != Pending, "Certificate already Pending");
		require(CertificatesList[_hash].status != Approved, "Certificate already Approved");
		require(CertificatesList[_hash].status != Suspended, "Certificate already Suspended");
		require(CertificatesList[_hash].status != None, "Certificate Not Found");

		require(CertificatesList[_hash].status == Request);
		
		bool result = false;		
		CertificatesList[_hash].status = Pending;
		result = true;
		
		return result;
		
	}
	
	function _certificateApproving(string memory _hash, uint256 _expiration_date) public returns (bool) {
		//require(admins._adminStatus(msg.sender, msg.sender) == Approved);
		//require(CertificatesList[_hash].status != Request, "Certificate already Request");
		require(CertificatesList[_hash].status != Approved, "Certificate already Approved");
		//require(CertificatesList[_hash].status != Suspended, "Certificate already Suspended");
		require(CertificatesList[_hash].status != None, "Certificate Not Found");

		//require(CertificatesList[_hash].status == Pending);

		bool result = false;		
		CertificatesList[_hash].expiration_date = _expiration_date;
		CertificatesList[_hash].status = Approved;
		result = true;
		
		return result;
		
	}
	
	function _certificateSuspending(string memory _hash) public returns (bool) {
		//require(admins._adminStatus(msg.sender, msg.sender) == Approved);
		require(CertificatesList[_hash].status != Suspended, "Certificate already Suspended");
		require(CertificatesList[_hash].status != None, "Certificate Not Found");
		
		bool result = false;
		CertificatesList[_hash].status = Suspended;
		result = true;
		
		return result;
		
	}

}
