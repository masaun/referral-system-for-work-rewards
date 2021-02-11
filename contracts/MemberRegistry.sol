pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";


/**
 * @title - The member registry contract
 */
contract MemberRegistry is Ownable {
    
    enum MemberType { Employee, Coalition, Staker }

    struct Member {  /// [Key]: index number of array
        address memberAddress;
        MemberType memberType;
        address referrerMemberAddress;  /// A member who is existing member and refer
    }
    Member[] members;

    constructor() public {}

    /**
     * @notice - Register a new member
     */
    function registerMember(address _newMember, MemberType _memberType, address _referrerMember) public returns (bool) {
        Member memory member = Member({
            memberAddress: _newMember,
            memberType: _memberType,
            referrerMemberAddress: _referrerMember
        });
        members.push(member);
    }


    ///-------------------------------
    /// Getter methods
    ///-------------------------------
    function getAllMembers() public view returns (Member[] memory _members) {
        return members;
    }

    
}
