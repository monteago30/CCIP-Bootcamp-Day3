import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { Sender__factory } from "../typechain-types";


// define a test suite for Sender and Receiver
describe("Gas Estimation with Fixture", function () {
    const chainSelector = "16015286601757825753";

    async function deployedContractsFixture() {
        console.log("Starting contract deployment...");

        // Get the signers
        const [deployer] = await ethers.getSigners();
        console.log("Deployer address:", deployer.address);

        const CCIPRouter = await ethers.getContractFactory("MockCCIPRouter");
        const CCIPSender = await ethers.getContractFactory("Sender");
        const CCIPReceiver = await ethers.getContractFactory("Receiver");
        const BurnMintERC677 = await ethers.getContractFactory("BurnMintERC677");

        // Initiate the contracts
        const cciprouter = await CCIPRouter.deploy();
        const cciplink = await BurnMintERC677.deploy(
            "ChainLink Token",
            "LINK",
            18,
            BigInt(1e27)
        );
        const ccipsender = await CCIPSender.deploy(cciprouter, cciplink);
        const ccipreceiver = await CCIPReceiver.deploy(cciprouter);


        // Setup allowlists for chains and sender addresses for the test scenario
        await ccipsender.allowlistDestinationChain(chainSelector, true);
        await ccipreceiver.allowlistSourceChain(chainSelector, true);
        await ccipreceiver.allowlistSender(ccipsender, true);

        // Return the deployed instances and the owner for use in tests.
        return { deployer, ccipsender, ccipreceiver, cciprouter, cciplink };
    }

    // Test scenario to send a CCIP message from sender to receiver and assess gas usage
    it("Should deploy deployContractsFixture contract...", async function () {
        // Deploy contracts and load their instances
        console.log("Loading Fixture...");
        const { ccipsender, ccipreceiver, cciprouter } = await loadFixture(deployedContractsFixture);

        // Define parameters for the tests, including gas limit and iterations for message.
        const gasLimit = 400000;
        const testParams = [0, 50, 99]; // Different iteration values for testing
        const gasUsageReport = []; // To store reports of gas used for each test.

        // Loop through each test parameter to send messages and record gas usage
        for (const iterations of testParams) {
            await ccipsender.sendMessagePayLINK(
                chainSelector,
                ccipreceiver,
                iterations,
                gasLimit
            );
            // Retrieve gas used from the last message executed by querying the router's events.
            const mockCCIPRouterEvents = await cciprouter.queryFilter(
                cciprouter.filters.MsgExecuted
            );
            const mockCCIPRouterEvent = mockCCIPRouterEvents[mockCCIPRouterEvents.length - 1]; //check th elast event
            const gasUsed = mockCCIPRouterEvent.args.gasUsed;

            // Push the report of iterations and gas used to the array.
            gasUsageReport.push({
                iterations,
                gasUsed: gasUsed.toString(),
            });
        }

        // Log the final report of gas usage for each iteration.
        console.log("Final Gas Usage Report:");
        gasUsageReport.forEach((report) => {
            console.log(
                "Number of iterations %d - Gas used: %d",
                report.iterations,
                report.gasUsed
            );
        });
    });
});