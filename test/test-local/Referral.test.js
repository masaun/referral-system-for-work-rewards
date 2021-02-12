/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

/// Openzeppelin test-helper
const { time } = require('@openzeppelin/test-helpers');

/// Artifact of smart contracts 
const Referral = artifacts.require("Referral");
const PayrollMining = artifacts.require("PayrollMining");
const MemberRegistry = artifacts.require("MemberRegistry");
const WorkRewardToken = artifacts.require("WorkRewardToken");
const ReferralNFT = artifacts.require("ReferralNFT");


/***
 * @dev - Execution COMMAND: $ truffle test ./test/test-local/Referral.test.js
 **/
contract("Referral", function(accounts) {
    /// Acccounts
    let deployer = accounts[0];
    let user1 = accounts[1];
    let user2 = accounts[2];
    let user3 = accounts[3];
    let user4 = accounts[4];
    let user5 = accounts[5];
    let user6 = accounts[6];

    /// Global contract instance
    let referral;
    let payrollMining;
    let memberRegistry;
    let workRewardToken;
    let referralNFT;

    /// Global variable for each contract addresses
    let REFERRAL;
    let PAYROLL_MINING;
    let MEMBER_REGISTRY;
    let WORK_REWARD_TOKEN;
    let REFERRAL_NFT;

    let LINKDROP_MASTER_1;
    let LINKDROP_MASTER_2;
    let LINKDROP_MASTER_3;

    let LINKDROP_FACTORY_1;
    let LINKDROP_FACTORY_2;
    let LINKDROP_FACTORY_3;

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

        it("Deploy the ReferralNFT contract instance", async () => {
            referralNFT = await ReferralNFT.new({ from: deployer });
            REFERRAL_NFT = referralNFT.address;
        });

        it("Deploy the PayrollMining contract instance", async () => {
            payrollMining = await PayrollMining.new(MEMBER_REGISTRY, WORK_REWARD_TOKEN, { from: deployer });
            PAYROLL_MINING = payrollMining.address;
        });

        it("Deploy the Referral contract instance", async () => {
            referral = await Referral.new(MEMBER_REGISTRY, WORK_REWARD_TOKEN, REFERRAL_NFT, { from: deployer });
            REFERRAL = referral.address;
        });
    });

    describe("Preparation for testing", () => {
        it("1000 $WORK should be transferred into 3 users (each wallet addresses)", async () => {
            const amount = web3.utils.toWei('1000', 'ether');
            let txReceipt1 = await workRewardToken.transfer(user1, amount, { from: deployer });
            let txReceipt2 = await workRewardToken.transfer(user2, amount, { from: deployer });
            let txReceipt3 = await workRewardToken.transfer(user3, amount, { from: deployer });
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
        it("A new referral NFT should be minted to user1", async () => {
            let txReceipt = await referralNFT.mintTo(user1, { from: user1 });
            const _currentTokenId = await referralNFT.currentTokenId({ from: user1 });
            console.log('=== _currentTokenId ===', String(_currentTokenId));
        });

        it("A new referral link should be created", async () => {
            const _weiAmount = web3.utils.toWei('5', 'ether');      /// 5 $WORK
            const _nftAddress = REFERRAL_NFT;                       /// Referral NFT token
            const _tokenId = await referralNFT.currentTokenId({ from: user1 });  /// new tokenId of the Referral NFT token
            const _expiration = await time.latest();                /// The latest timestamp
            const _linkId = user1;
            const _signature = "0x7465737400000000000000000000000000000000000000000000000000000000";  /// bytes32 type signature
            let txReceipt = await referral.createReferralLink(_weiAmount, _nftAddress, _tokenId, _expiration, _linkId, _signature, { from: user1 });

            /// [Note]: Retrieve an event log via web3.js v1.0.0
            let eventOfLinkdropMasterCreated = await referral.getPastEvents('LinkdropMasterCreated', {
                filter: {},  /// [Note]: If "index" is used for some event property, index number is specified
                fromBlock: 0,
                toBlock: 'latest'
            });

            let eventOfLinkdropFactoryCreated = await referral.getPastEvents('LinkdropFactoryCreated', {
                filter: {},  /// [Note]: If "index" is used for some event property, index number is specified
                fromBlock: 0,
                toBlock: 'latest'
            });

            console.log("\n=== Event log of LinkdropMasterCreated ===", eventOfLinkdropMasterCreated[0].returnValues);
            console.log("\n=== Event log of LinkdropFactoryCreated ===", eventOfLinkdropFactoryCreated[0].returnValues);

            LINKDROP_MASTER_1 = eventOfLinkdropMasterCreated[0].returnValues.linkdropMaster;
            LINKDROP_FACTORY_1 = eventOfLinkdropFactoryCreated[0].returnValues.linkdropFactory;
        });

        it("A new referral link should be verified", async () => {
            const _linkdropMaster = LINKDROP_MASTER_1;
            const _linkId = user1;
            const _receiver = user2;
            const _signature = "0x5161587200000000000000000000000000000000000000000000000000000000";  /// bytes32 type signature
            let txReceipt = await referral.verifyReferralLink(_linkdropMaster, _linkId, _receiver, _signature, { from: user1 });
        });

        it("A claimed-link should be successful", async () => {
            const _linkdropFactory = LINKDROP_FACTORY_1;
            const _weiAmount = web3.utils.toWei('5', 'ether');      /// 5 $WORK
            const _nftAddress = REFERRAL_NFT;                       /// Referral NFT token
            const _tokenId = 1;                                     /// tokenId of the Referral NFT token
            const _expiration = await time.latest();                /// The latest timestamp
            const _linkId = user1;
            const _linkdropMaster = LINKDROP_MASTER_1;
            const _campaignId = 0;
            const _linkdropSignerSignature = "0x7465737400000000000000000000000000000000000000000000000000000000";  /// bytes32 type signature
            const _receiver = user2;
            const _receiverSignature = "0x5161587200000000000000000000000000000000000000000000000000000000";  /// bytes32 type signature

            // Approving tokens from linkdropMaster to Linkdrop Contract
            await workRewardToken.approve(REFERRAL, _tokenAmount)

            let txReceipt = await referral.claimLink(_linkdropFactory, _weiAmount, _tokenAddress, _tokenAmount, _expiration, _linkId, _linkdropMaster, _campaignId, _linkdropSignerSignature, _receiver, _receiverSignature, { from: user2 });
        });
    });

    describe("Payroll Block Mining", () => {
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

        it("A referred-member should consume payroll service on Opolis platform so that a referrer member enable to get $WORK rewards", async () => {
            const _member = user1;
            let txReceipt = await memberRegistry.consumePayrollService(_member, { from: user1 });

            let _isMemberConsumingService = await memberRegistry.isMemberConsumingService(_member, { from: user1 });
            console.log('\n=== _isMemberConsumingService ===', _isMemberConsumingService);
            assert.equal(
                _isMemberConsumingService,
                true,
                "A referred-member should consume payroll service on Opolis platform so that a referrer member enable to get $WORK rewards"
            );
        });

        it("Update 'Payroll Mining Block' and distribute $WORK rewards into members when specified-condition is fulfilled", async () => {
            /// [Todo]:
            const latestPeriodicPayrollVolume = web3.utils.toWei('10000', 'ether');  /// 10000 $WORK
            let txReceipt = await payrollMining.updateBlock({ from: deployer });
        });
    });

});
