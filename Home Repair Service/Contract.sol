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
    address payable public owner;
    uint256 homeRepairerBalance;

    constructor() {
        // Let's say that the owner has an account and it's the following one:
        owner = payable(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);
    }
    function deposit() public payable {}

    // 1. Add a repair request
    function addRepairRequest(
        string memory requestDescription,
        uint256 requestId
    ) external {
        request[requestId].description = requestDescription;
    }

    // 2. Accept a repair request
    function acceptRepairRequest(uint256 requestId, uint256 price) public {
        require(
            bytes(request[requestId].description).length > 0,
            "Request with given id does not exist!"
        );
        require(price > 0, "Price should be a valid number!");
        request[requestId].isAccepted = true;
        request[requestId].price = price;
    }

    // 3. Add a payment
    function addPayment(address payable repairer ,uint amount, uint256 id) public payable  {
        require(amount > 0, "Price should be a valid number!"); 
        require(amount == request[id].price, "Invalid price!"); 
        repairer.transfer(amount);
    }

    // 4. Confirm a repair request
    function confirmRequest(uint256 id) public {
        require(
            bytes(request[id].description).length > 0,
            "Request with given id does not exist!"
        );

        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        for (uint256 i = 0; i < request[id].isConfirmed.length; i++) {
            if (request[id].isConfirmed[i] == msg.sender) {
                require(false, "You already accepted this request!");
            }
        }
        request[id].isConfirmed.push(msg.sender);
    }

    // 5. Verify that the job is done
    function jobVerify(uint256 id) public {
        require(
            bytes(request[id].description).length > 0,
            "Request with given id does not exist!"
        );
        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        request[id].isJobDone = true;
    }

    // 6. Execute a repair request
    // You did not specify If the payment will proceed in task 2 or in task 6, there is payment in both!
    function paying(uint256 id) public {
        require(
            bytes(request[id].description).length > 0,
            "Request with given id does not exist!"
        );

        require(
            request[id].isAccepted == true,
            "Request has not been accepted yet!"
        );
        require(
            request[id].isConfirmed.length >= 2,
            "The request was not confirmed by at least 2 auditors!"
        );
        homeRepairerBalance += request[id].price;
    }

    // 7. Money Back
    function takeMoneyBack() public {
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
        // require(
        //     bytes(request[id].description).length > 0,
        //     "Request with given id does not exist!"
        // );
        // require(
        //     homeRepairerBalance >= request[id].price,
        //     "You did not pay your repair!"
        // );
        // homeRepairerBalance -= request[id].price;
    }
}
