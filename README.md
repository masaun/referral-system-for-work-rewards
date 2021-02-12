# Referral System for $WORK Rewards

***
## 【Introduction of the Referral System for $WORK Rewards】
- This is a smart contract to deliver a functioning referral system for the $WORK token.
  - Unique, sharable referral links for each Member who is referring new Members to Opolis
  - 5M $WORK Rewards are issued per “Payroll Mining Block” to Employee Members, Coalition Members and Stakers. 
  - Blocks are mined as the Network grows by increments of $50K or 5% in periodic payroll volume, whichever is greater. 
  - Members receive 100% of the referral credit for Employee Members who join
  - Members receive 15% of the referral credit for referring Coalition Organizations who act as channel partners for referring new Employee Members. 
    - NO multi-level referral credit except for referring Organizations where the referring Member receives 15%) 
  - All members receive $WORK Rewards in perpetuity so long as the referred Member consumes services. 
    (Those specifications above follow https://www.ethdenver.com/post/opolis)

&nbsp;

***

## 【Workflow】
- 


&nbsp;

***

## 【Remarks】
- Version
  - Solidity (Solc): v0.5.16
  - Truffle: v5.1.60
  - web3.js: v1.2.9
  - openzeppelin-solidity: v2.2.0
  - ganache-cli: v6.9.1 (ganache-core: 2.10.2)


&nbsp;

***

## 【Setup】
### ① Install modules
- Install npm modules in the root directory
```
$ npm install
```

<br>

### ② Compile & migrate contracts (on local)
```
$ npm run migrate:local
```

<br>

### ③ Test (Mainnet-fork approach)
- 1: Start ganache-cli
```
$ ganache-cli -d
```
(※ `-d` option is the option in order to be able to use same address on Ganache-CLI every time)

<br>

- 2: Execute test of the smart-contracts (on the local)
  - Test for the contract
    - `$ npm run test:referral`
       ($ truffle test ./test/test-local/Referral.test.js)

    - `$ npm run test:payroll_mining`
       ($ truffle test ./test/test-local/PayrollMining.test.js)

<br>


***

## 【References】
- Opolis
  - Reward Structure 
    https://opolis.co/rewards/

  - Opolis bounty in the ETHDenver 2021 (OPOLIS BOUNTY: Build a Referral System for $WORK Rewards)  
    https://www.ethdenver.com/post/opolis

<br>

- Linkdrop
  - Linkdrop contract  
    https://github.com/LinkdropHQ/linkdrop-monorepo/tree/master/packages/contracts

  - Technology Overview (ERC20 & NFT Linkdrop)
    https://medium.com/volc%C3%A0/technology-overview-erc20-nft-linkdrop-c2909f9bcd19
