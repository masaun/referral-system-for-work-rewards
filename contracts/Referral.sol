pragma solidity ^0.6.12;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { MemberRegistry } from "./MemberRegistry.sol";


/**
 * @notice - Members receive 100% of the referral credit for Employee Members who join
 * @notice - Members receive 15% of the referral credit for referring Coalition Organizations who act as channel partners for referring new Employee Members.
 * @notice - NO multi-level referral credit except for referring Organizations where the referring Member receives 15%. 
 */
contract Referral is Ownable {
    
    /**
     * Entire Process
     * ① Deploy a Linkdrop Contract
     * ② Generate claim links
     * ③ Send links to friends
     * ④ One of Alice’s friends (Bob) can follow the link and claim the tokens
     */

    uint referralCredit;

    MemberRegistry public memberRegistry;

    constructor(MemberRegistry _memberRegistry) public {
        memberRegistry = _memberRegistry;
    }


}
