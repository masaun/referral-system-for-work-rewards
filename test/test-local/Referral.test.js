/// Using local network
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.WebsocketProvider('ws://localhost:8545'));

/// Openzeppelin test-helper
const { time } = require('@openzeppelin/test-helpers');

/// Artifact of smart contracts 
const Referral = artifacts.require("Referral");


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

    /// Global variable for each contract addresses
    let REFERRAL;


    describe("Check state in advance", () => {
        it("Check all accounts", async () => {
            console.log('\n=== accounts ===\n', accounts, '\n========================\n');
        }); 
    }); 

    describe("Setup smart-contracts", () => {
        it("Deploy the Referral contract instance", async () => {
            const owner = deployer;
            referral = await Referral.new(owner, { from: deployer });
            REFERRAL = referral.address;
        });
    });

});
