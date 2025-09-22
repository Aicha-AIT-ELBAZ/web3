// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

contract Contract {
    struct Waqf {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping(uint256 => Waqf) public awqaf;
    uint256 public numberOfAwqaf = 0;
    function createWaqf(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        Waqf storage waqf = awqaf[numberOfAwqaf];
        require(
            waqf.deadline < block.timestamp,
            "The deadline shoud be in the future"
        );
        waqf.owner = _owner;
        waqf.title = _title;
        waqf.description = _description;
        waqf.target = _target;
        waqf.deadline = _deadline;
        waqf.amountCollected = 0;
        waqf.image = _image;

        numberOfAwqaf++;
        return numberOfAwqaf - 1;
    }
    function donateToWaqf(uint256 _id) public payable {
        uint256 amount = msg.value;
        Waqf storage waqf = awqaf[_id];
        waqf.donators.push(msg.sender);
        waqf.donations.push(amount);

        (bool sent, ) = payable(waqf.owner).call{value: amount}("");
        if (sent) {
            waqf.amountCollected = waqf.amountCollected + amount;
        }
    }
    function getDonators(uint256 _id) view public returns (address[] memory,uint256[] memory){
        return (awqaf[_id].donators, awqaf[_id].donations);
        
    }
    function getAwqaf() public view returns(Waqf[] memory) {
        Waqf[] memory allAwqaf=new Waqf[](numberOfAwqaf); 
        for(uint i = 0; i< numberOfAwqaf;i++){
            Waqf storage item =awqaf[i];

            allAwqaf[i] = item ;

        }
        return allAwqaf;

    }
}
