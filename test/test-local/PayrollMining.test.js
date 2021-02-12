/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

/// Openzeppelin test-helper
const { time } = require('@openzeppelin/test-helpers');

/// Artifact of smart contracts 
const PayrollMining = artifacts.require("PayrollMining");
const MemberRegistry = artifacts.require("MemberRegistry");
const WorkRewardToken = artifacts.require("WorkRewardToken");


/***
 * @dev - Execution COMMAND: $ truffle test ./test/test-local/Referral.test.js
 **/
contract("PayrollMining", function(accounts) {
    /// Acccounts
    let deployer = accounts[0];
    let user1 = accounts[1];
    let user2 = accounts[2];
    let user3 = accounts[3];
    let user4 = accounts[4];
    let user5 = accounts[5];
    let user6 = accounts[6];

    /// Global contract instance
    let payrollMining;
    let memberRegistry;
    let workRewardToken;

    /// Global variable for each contract addresses
    let PAYROLL_MINING;
    let MEMBER_REGISTRY;
    let WORK_REWARD_TOKEN;

    describe("Check state in advance", () => {
        it("Check all accounts", async () => {
            console.log('\n=== accounts ===\n', accounts, '\n========================\n');
        }); 
    }); 

    describe("Setup smart-contracts", () => {
        it("Deploy the MemberRegistry contract instance", async () => {
            memberRegistry = await MemberRegistry.new({ from: deployer });
            MEMBER_REGISTRY = memberRegistry.address;
        });

        it("Deploy the WorkRewardToken contract instance", async () => {
            workRewardToken = await WorkRewardToken.new({ from: deployer });
            WORK_REWARD_TOKEN = workRewardToken.address;
        });

        it("Deploy the PayrollMining contract instance", async () => {
            payrollMining = await PayrollMining.new(MEMBER_REGISTRY, WORK_REWARD_TOKEN, { from: deployer });
            PAYROLL_MINING = payrollMining.address;
        });
    });

    describe("Preparation for testing", () => {
        it("1000 $WORK should be transferred into 3 users (each wallet addresses)", async () => {
            const amount = web3.utils.toWei('1000', 'ether');
            let txReceipt1 = await workRewardToken.transfer(user1, amount, { from: deployer });
            let txReceipt2 = await workRewardToken.transfer(user2, amount, { from: deployer });
            let txReceipt3 = await workRewardToken.transfer(user3, amount, { from: deployer });
        });

        it("3 users (wallet addresses) register as a member", async () => {
            let txReceipt1 = await memberRegistry.registerMember(user1, 0, user4, { from: user1 });  /// [Note]: MemberType is "Employee"
            let txReceipt2 = await memberRegistry.registerMember(user2, 1, user5, { from: user2 });  /// [Note]: MemberType is "Coalition"
            let txReceipt3 = await memberRegistry.registerMember(user3, 2, user6, { from: user3 });  /// [Note]: MemberType is "Staker"
        });

        it("Number of all members registered should be 3", async () => {
            let allMembers = await memberRegistry.getAllMembers({ from: deployer });
            let numberOfAllMembers = allMembers.length;
            console.log('\n=== allMembers ===', allMembers);
            console.log('\n=== numberOfAllMembers ===', numberOfAllMembers);
            assert.equal(
                Number(numberOfAllMembers),
                3,
                "Number of all members registered should be 3"
            );
        });
    });

    describe("Payroll Block Mining", () => {
        it("A referred-member consume some service on Opolis platform", async () => {
            const _member = user1;
            let txReceipt = await memberRegistry.consumeSomeService(_member, { from: user1 });
        });
        
        it("Update 'Payroll Mining Block' when specified-condition is fulfilled.", async () => {
            /// [Todo]:
            const latestPeriodicPayrollVolume = web3.utils.toWei('10000', 'ether');  /// 10000 $WORK
            let txReceipt = await payrollMining.updateBlock({ from: deployer });
        });
    });

});
