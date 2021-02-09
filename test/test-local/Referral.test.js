/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

/// Openzeppelin test-helper
const { time } = require('@openzeppelin/test-helpers');

/// Artifact of smart contracts 
const Referral = artifacts.require("Referral");
const MemberRegistry = artifacts.require("MemberRegistry");
const WorkRewardToken = artifacts.require("WorkRewardToken");


/***
 * @dev - Execution COMMAND: $ truffle test ./test/test-local/Referral.test.js
 **/
contract("Referral", function(accounts) {
    /// Acccounts
    let deployer = accounts[0];
    let user1 = accounts[1];
    let user2 = accounts[2];
    let user3 = accounts[3];

    /// Global Tokenization contract instance
    let referral;
    let memberRegistry;
    let workRewardToken;

    /// Global variable for each contract addresses
    let REFERRAL;
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

        it("Deploy the Referral contract instance", async () => {
            referral = await Referral.new(MEMBER_REGISTRY, { from: deployer });
            REFERRAL = referral.address;
        });

        it("Deploy the WorkRewardToken contract instance", async () => {
            workRewardToken = await WorkRewardToken.new({ from: deployer });
            WORK_REWARD_TOKEN = workRewardToken.address;
        });

        it("1000 $WORK should be transferred into user1 wallet address", async () => {
            const amount = web3.utils.toWei('1000', 'ether');
            let txReceipt = workRewardToken.transfer(user1, amount);
        });
    });

    describe("Grant a referral credit", () => {
        it("should grant a referral credit", async () => {
            const memberAddress = user1;
            const referralCreditType = 1;
            let txReceipt = await referral.grantReferralCredit(memberAddress, referralCreditType, { from: user1 });
        });
    });

    describe("Referral process", () => {
        it("should create a new referral link", async () => {
            const _weiAmount = web3.utils.toWei('5', 'ether');      /// 5 $WORK
            const _tokenAddress = WORK_REWARD_TOKEN;                /// $WORK token
            const _tokenAmount = web3.utils.toWei('100', 'ether');  /// 100 $WORK
            const _expiration = await time.latest();                /// The latest timestamp
            const _linkId = user1;
            const _signature = "0x7465737400000000000000000000000000000000000000000000000000000000"
            txReceipt = await referral.createReferralLink(_weiAmount, _tokenAddress, _tokenAmount, _expiration, _linkId, _signature, { from: user1 });
        });
    });

});
