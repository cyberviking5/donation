// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationTracker {
    struct Donation {
        address donor;
        uint amount;
        uint timestamp;
    }

    mapping(address => Donation[]) public donations;

    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        donations[msg.sender].push(Donation({
            donor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp
        }));
    }

    function getTotalDonationByUser(address user) public view returns (uint) {
        uint totalDonation = 0;
        Donation[] memory userDonations = donations[user];
        
        for (uint i = 0; i < userDonations.length; i++) {
            totalDonation += userDonations[i].amount;
        }
        
        return totalDonation;
    }

    function getTotalDonation() public view returns (uint) {
        uint totalDonation = 0;
        address[] memory users = getAllUsers();
        
        for (uint i = 0; i < users.length; i++) {
            totalDonation += getTotalDonationByUser(users[i]);
        }
        
        return totalDonation;
    }

   function getAllUsers() public view returns (address[] memory) {
    address[] memory users;
    for (uint i = 0; i < msg.sender.balance; i++) {
        if (donations[msg.sender][i].donor != address(0)) {
            users[i] = donations[msg.sender][i].donor;
        }
    }
    return users;
}

}
