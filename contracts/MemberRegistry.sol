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
        bool consumePayrollService;            /// A property in order to judge whether a member consume payroll service on Opolis or not
    }
    Member[] members;

    address[] memberAddresses;

    constructor() public {}

    /**
     * @notice - Register a new member
     */
    function registerMember(address _newMember, MemberType _memberType, address _referrerMember) public returns (bool) {
        Member memory member = Member({
            memberAddress: _newMember,
            memberType: _memberType,
            referrerMemberAddress: _referrerMember,
            consumePayrollService: false
        });
        members.push(member);
        memberAddresses.push(_newMember);
    }

    /**
     * @notice - Test method that assuming a member consume payroll service on Opolis platform
     */
    function consumePayrollService(address _member) public returns (bool) {
        /// Identify member's index
        uint memberIndex;
        for (uint i=0; i < memberAddresses.length; i++) {
            if (memberAddresses[i] == _member) {
                memberIndex = i;
            }
        }

        /// Update only a property of "consumePayrollService"
        Member storage member = members[memberIndex];    
        member.consumePayrollService = true;
    }    


    ///-------------------------------
    /// Getter methods
    ///-------------------------------
    function getAllMembers() public view returns (Member[] memory _members) {
        return members;
    }

    function getMember(address member) public view returns (Member memory _member) {
        /// Identify member's index
        uint memberIndex;
        for (uint i=0; i < memberAddresses.length; i++) {
            if (memberAddresses[i] == member) {
                memberIndex = i;
            }
        }

        Member memory member = members[memberIndex];
        return member;
    }

    function isMemberConsumingService(address member) public view returns (bool _isMemberConsumingService) {
        /// Identify member's index
        uint memberIndex;
        for (uint i=0; i < memberAddresses.length; i++) {
            if (memberAddresses[i] == member) {
                memberIndex = i;
            }
        }

        Member memory member = members[memberIndex];
        return member.consumePayrollService;
    }
    
}
