// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/* Imports */
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
* @title Ruffle - A Simple Raffle Contract
* @author Martin Shoylev
* @notice This contract is for creeating a sample raffle
* @dev Implements Chainlink VRFv2.5
*/

contract Ruffle {
    /* Errors */
    error Ruffle__SendMoretoEnterRaffle();

     /* State variables */
    uint256 private immutable i_enranceFee;
    // @dev the duration of the lottary seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee, uint256 interval) {
        i_enranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function entereRaffle(uint256 entranceFee) external payable{
        // require(msg.value >= i_enranceFee, "Not enough ETH");
        // require(msg.value >= i_enranceFee, SendMoretoEnterRaffle());
        if(msg.value < i_enranceFee){
            revert Ruffle__SendMoretoEnterRaffle();
        }
        s_players.push(payable(msg.sender));
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {
        if((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert();
        }

        requestId = s_vrfCoorinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subId,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                 extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            })
        );
    }

    /**
    * Getter Functions
    */
    function getEntracnceFee() external view returns (uint256) {
        return i_enranceFee;
    }
}