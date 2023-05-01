// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract HomeRepair {
    address public owner;
    mapping(uint256 => string) public requests;
    mapping(uint256 => bool) public acceptedRequests;
    mapping(uint256 => uint256) public prices;
    mapping(uint256 => bool) public confirmRequest;
    
    constructor() {
        owner = msg.sender;
    }

    // 1. Add a repair request
    function addRepairRequest(
        string memory requestDescription,
        uint256 requestId
    ) external {
        requests[requestId] = requestDescription;
        acceptedRequests[requestId] = false;
    }

    // 2. Accept a repair request
    function acceptRepairRequest(uint256 requestId) public {
        acceptedRequests[requestId] = true;
    }

    // 3. Add a payment
    function addPayment(uint256 id, uint256 price) public {
        require(
            bytes(requests[id]).length > 0,
            "Request with given id does not exist!"
        );
        require(price > 0, "Price should be a valid number!");
        require(
            acceptedRequests[id] == true,
            "Request has not been accepted yet!"
        );
        prices[id] = price;
    }

    // 4. Confirm a repair request
    function confirmRequest(uint256 id) public {
        require(
            bytes(requests[id]).length > 0,
            "Request with given id does not exist!"
        );
        require(
            acceptedRequests[id] == true,
            "Request has not been accepted yet!"
        );
        confirmedRequests[id] = true;
    }
}
