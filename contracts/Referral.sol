pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @notice - Members receive 100% of the referral credit for Employee Members who join
 * @notice - Members receive 15% of the referral credit for referring Coalition Organizations who act as channel partners for referring new Employee Members.
 * @notice - NO multi-level referral credit except for referring Organizations where the referring Member receives 15%. 
 */
contract Referral is Ownable {
    
    constructor() public {}

}
