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
        bool consumeService;            /// A property in order to judge whether a member consume some service on Opolis or not
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
            consumeService: false
        });
        members.push(member);
        memberAddresses.push(_newMember);
    }

    /**
     * @notice - Test method that assuming a member consume some service on Opolis platform
     */
    function consumeSomeService(address _member) public returns (bool) {
        /// Identify member's index
        uint memberIndex;
        for (uint i=0; i < memberAddresses.length; i++) {
            if (memberAddresses[i] == _member) {
                memberIndex = i;
            }
        }

        /// Update only a property of "consumeService"
        Member storage member = members[memberIndex];    
        member.consumeService = true;
    }    


    ///-------------------------------
    /// Getter methods
    ///-------------------------------
    function getAllMembers() public view returns (Member[] memory _members) {
        return members;
    }
    
}
