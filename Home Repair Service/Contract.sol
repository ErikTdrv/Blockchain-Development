// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract HomeRepair {
    address public owner;
    mapping (uint256 => string) public requests;
    mapping (uint256 => bool) public acceptedRequests;

    constructor() {
        owner = msg.sender;
    }

    // 1. Add a repair request
    function addRepairRequest(string memory requestDescription, uint256 requestId) external {
        requests[requestId] = requestDescription;
        acceptedRequests[requestId] = false;
    }
   

}