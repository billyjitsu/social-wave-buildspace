// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    /*
     * This is an address => uint mapping, meaning I can associated an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    /*
     * A little magic, Google what events are in Solodity!
     */
    event NewWave(address indexed from, uint256 timestamp, string message);

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;

    constructor() payable {
        console.log("Contract #3 fancy Waves with payout");
    }

    /*
     * You'll notice I changed the wave function a little here as well and
     * now it requires a string called _message. This is the message out user
     * sends us from the frontend!
     */
    function wave(string memory _message) public {
         /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(lastWavedAt[msg.sender] + 20 seconds < block.timestamp, "Wait 15m");

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        /*
         * This is where I actually store the wave data in the array.
         */
        waves.push(Wave(msg.sender, _message, block.timestamp));

         /*
         * Generate a Psuedo random number between 0 and 100
         */
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        /*
         * Set the generated, random number as the seed for the next wave
         */
        seed = randomNumber;

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);


        uint256 prizeAmount = 0.0001 ether;
        require(prizeAmount <= address(this).balance, "Trying to withdraw more money than they contract has.");
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");  //Call cannot be used without a parameter
        require(success, "Failed to withdraw money from contract.");
        }
        /*
         * I added some fanciness here, Google it and try to figure out what it is!
         * Let me know what you learn in #course-chat
         */
        emit NewWave(msg.sender, block.timestamp, _message);

        
    }

    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}