pragma solidity ^0.6.12;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title - The member registry contract
 */
contract MemberRegistry is Ownable {
    
    enum MemberType { Employee, Coalition, Staker }

    struct Member {  /// [Key]: index number of array
        address memberAddress;
        MemberType memberType;
    }
    Member[] members;

    constructor() public {}

    /**
     * @notice - Register a new member
     */
    function registerMember(address _memberAddress, MemberType _memberType) public returns (bool) {
        Member memory member = Member({
            memberAddress: _memberAddress,
            memberType: _memberType
        });
        members.push(member);
    }

}
