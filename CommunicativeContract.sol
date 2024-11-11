// contracts/CommunicativeContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract CommunicativeContract {
    struct ContractWhitelistStruct {
        uint id;
        string name;
        address contractAddress;
    }

    ContractWhitelistStruct[] private contractWhitelist;
    mapping(address => uint) private contractWhitelistID;

    // Contract Information
    address public owner;
    string public contract_name;
    address thisContract;

    constructor(string memory _contract_name) {
        owner = msg.sender;
        thisContract = address(this);
        contract_name = _contract_name;
    }

    function checkIsOwner() public view returns(bool){
        require((msg.sender == owner) || (tx.origin == owner), "You are not allowed to access this information.");
        return true;
    }

    /*      -------- --------- --------- ----       */
    //
    //      Contract Whitelist Mechanism Here
    //
    /*      -------- --------- --------- ----       */

    function addContract(string memory contractName, address contractAddress) public returns(bool){
        require(checkIsOwner());
        
        contractWhitelistID[contractAddress] = contractWhitelist.length;

        contractWhitelist.push(
            ContractWhitelistStruct({
                id: contractWhitelistID[contractAddress],
                name: contractName,
                contractAddress: contractAddress
        }));

        return true;
    }

    function getContractAddress(address _targetContract) public view returns(address){
        require(isContractAllowed(_targetContract));

        ContractWhitelistStruct storage targetContract = contractWhitelist[contractWhitelistID[_targetContract]];

        return targetContract.contractAddress;
    }

    function isContractAllowed(address _contract_name) public view returns(bool){
        require(contractWhitelist[contractWhitelistID[_contract_name]].contractAddress == _contract_name, "This contract address is not allowed!");
        return true;
    }
    
    function viewAllOtherContracts() public view returns(ContractWhitelistStruct[] memory) {
        checkIsOwner();

        return contractWhitelist;
    }
}
