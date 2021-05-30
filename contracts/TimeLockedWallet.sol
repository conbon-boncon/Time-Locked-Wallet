//SPDX-License-Identifier: MIT"

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract TimeLockedWallet is Ownable{

    address payable[] beneficiaries;

    enum Stage {Created, Locked, Release}
    Stage public currentStage;

    uint256 unlockTime;

    event Deposit();
    event WalletLocked();
    event Withdraw();


    constructor() {
        currentStage = Stage.Created;
    }

    function getBalance() public view returns(uint256){
        return (address(this).balance); 
    }

    function addBeneficiaries(address payable _beneficiary) public onlyOwner{
        require(currentStage == Stage.Created);
        beneficiaries.push(_beneficiary);
    }

    function setUnlockTime(uint256 _unlockTime) public{
        require(currentStage == Stage.Created);
        unlockTime =_unlockTime;
    }

    function getRemainingTime() public view returns (uint256){
        require(currentStage == Stage.Locked);
        return unlockTime - block.timestamp;
    }

    //Deposit money in Wallet
    function deposit() public payable{
        require(currentStage == Stage.Created);
        emit Deposit();
    }

    function lockWallet() public onlyOwner{
        require(address(this).balance > 0 && currentStage == Stage.Created);
        currentStage = Stage.Locked;
        emit WalletLocked();
        if(block.timestamp >= unlockTime){
            currentStage = Stage.Release;
        }
    }

    function withdraw() public payable onlyOwner{
        require(currentStage == Stage.Release);
        uint256 value = (address(this).balance / beneficiaries.length);
        
        for(uint i=0; i < beneficiaries.length; i++){
            beneficiaries[i].transfer(value);
        }

        emit Withdraw();
    }

    function helloWorld() public pure returns(string memory){
        return "Hello World";
    }
    
}