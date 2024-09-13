// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { MockCCIPRouter } from "@chainlink/contracts-ccip/src/v0.8/ccip/test/mocks/MockRouter.sol";
import { BurnMintERC677 } from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC677/BurnMintERC677.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import { Receiver } from "../src/Receiver.sol";
import { Sender } from "../src/Sender.sol";
import { Test, console, Vm } from "../lib/forge-std/src/Test.sol";
import "../lib/forge-std/src/Test.sol";

contract EstimateGas is Test {
    // Declaration of contracts and variables used int the tests
    Sender public ccipSender;
    Receiver public ccipReceiver;
    BurnMintERC677 public linkToken;
    MockCCIPRouter public mockRouter;
    // A specific chain selector for identifying the chain.
    uint64 ethSepoliaChainSelector = 16015286601757825753;

    function setUp() public {
        // Deploy MockCCIP Router contract, use it's address to deploy the CCIP Sender and Receiver Contracts.
        mockRouter = new MockCCIPRouter();

        // Link token contract
        linkToken = new BurnMintERC677("ChainLink Token", "LINK", 18, 10 ** 27);

        // Deploy the CCIP Sender Contract with the Mock Router address
        ccipSender = new Sender(address(mockRouter), address(linkToken));

        // Deploy the CCIP Receiver Contract with the Mock Router address
        ccipReceiver = new Receiver(address(mockRouter));

        // Configuring allow list settings for testing cross-chain interactions
        ccipSender.allowlistDestinationChain(ethSepoliaChainSelector, true);
        ccipReceiver.allowlistSourceChain(ethSepoliaChainSelector, true);
        ccipReceiver.allowlistSender(address(ccipSender), true);
    }

    function testGasUseOfSendMessage(uint256 iterations) private {
        vm.recordLogs(); // Starts recording logs to capture events.
        ccipSender.sendMessagePayLINK(
            ethSepoliaChainSelector,
            address(ccipReceiver),
            iterations,
            400000 //  A predefined gas limit for the transaction.
        );

        // Fetches the recorded logs to check for specific events and their outcomes.
        Vm.Log[] memory mylogs = vm.getRecordedLogs();
        bytes32 msgExecutedSignature = keccak256(
            "MsgExecuted(bool,bytes,uint256)"
        );

        for (uint i = 0; i < mylogs.length; i++) {
            if (mylogs[i].topics[0] == msgExecutedSignature) {
                (, , uint256 gasUsed) = abi.decode(
                    mylogs[i].data,
                    (bool, bytes, uint256)
                );
                console.log(
                    "Number of iterations %d - Gas used: %d",
                    iterations,
                    gasUsed
                );
            }
        }
    }

    // Test case for the minimum number of iterations.
    function test_SendReceive() public {
        testGasUseOfSendMessage(0);
    }

    // Test case for an average number of iterations.
    function test_SendReceiveAverage() public {
        testGasUseOfSendMessage(50);
    }

    // Test case for the maximum number of iterations.
    function test_SendReceiveMax() public {
        testGasUseOfSendMessage(99);
    }
}