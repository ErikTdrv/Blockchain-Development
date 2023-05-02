// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract HomeRepair {
    struct MyData {
        string description;
        bool isAccepted;
        uint256 price;
        address[] isConfirmed;
        bool isJobDone;
    }
    mapping(uint256 => MyData) public request;
    address public owner;
    uint256 homeRepairerBalance;

    constructor() {
        owner = msg.sender;
    }

    // 1. Add a repair request
    function addRepairRequest(
        string memory requestDescription,
        uint256 requestId
    ) external {
        request[requestId].description = requestDescription;
    }

    // 2. Accept a repair request
    function acceptRepairRequest(uint256 requestId) public {
        request[requestId].isAccepted = true;
    }

    // 3. Add a payment
    function addPayment(uint256 id, uint256 price) public {
        // require(request[id].description.length != 0, "Request with given id does not exist!");
        require(price > 0, "Price should be a valid number!");
        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        request[id].price = price;
    }

    // 4. Confirm a repair request
    function confirmRequest(uint256 id) public {
        // require(bytes(requests[id]).length > 0, "Request with given id does not exist!");
        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        for(uint i = 0; i < request[id].isConfirmed.length; i++){
            if(request[id].isConfirmed[i] == owner){
                require(false, "You already accepted this request!");
            }
        }
        request[id].isConfirmed.push(owner);
    }

    // 5. Verify that the job is done
    function jobVerify(uint256 id) public {
        // require(bytes(requests[id]).length > 0, "Request with given id does not exist!");
        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        request[id].isJobDone = true;
    }

    // 6. Execute a repair request
    function paying(uint256 id) public {
        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        homeRepairerBalance += request[id].price;
    }
    // 7. Money Back
    function takeMoneyBack(uint256 id) public {
        require(homeRepairerBalance >= request[id].price, "You did not pay your repair!");
        homeRepairerBalance -= request[id].price;
    }
}