pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import { MemberRegistry } from "./MemberRegistry.sol";
import { LinkdropMastercopy } from "./linkdrop/linkdrop/LinkdropMastercopy.sol";


/**
 * @notice - Members receive 100% of the referral credit for Employee Members who join
 * @notice - Members receive 15% of the referral credit for referring Coalition Organizations who act as channel partners for referring new Employee Members.
 * @notice - NO multi-level referral credit except for referring Organizations where the referring Member receives 15%. 
 */
contract Referral is Ownable {

    /**
     * Entire Process for referral action
     * ① Deploy a Linkdrop Contract
     * ② Generate claim links
     * ③ Send links to friends
     * ④ One of Alice’s friends (Bob) can follow the link and claim the tokens
     */

    enum ReferralCreditType { EmployeeMember, CoalitionOrganization }

    uint referralCreditRatioForEmployeeMember = 100 * 1e18;        /// 100%
    uint referralCreditRatioForCoalitionOrganization = 15 * 1e18;  /// 15%

    address[] linkdropMasters;  /// All deployed LinkdropMaster contract address are assigned into here

    MemberRegistry public memberRegistry;

    constructor(MemberRegistry _memberRegistry) public {
        memberRegistry = _memberRegistry;
    }

    /**
     * @notice - Grant referral credit
     */
    function grantReferralCredit(address memberAddress, ReferralCreditType referralCreditType) public returns (bool) {
        uint referralCreditRatio;
        if (referralCreditType == ReferralCreditType.EmployeeMember) {
            referralCreditRatio = referralCreditRatioForEmployeeMember;         /// 100%
        } else if (referralCreditType == ReferralCreditType.CoalitionOrganization) {
            referralCreditRatio = referralCreditRatioForCoalitionOrganization;  /// 15%
        }
    }

    /**
     * @notice - Create unique and sharable referral links for each Member who is referring new Members to Opolis
     * @notice - LinkdropMaster is deployed every time to create a referral link
     * 
     * @dev Function to verify linkdrop signer's signature
     * @param _weiAmount Amount of wei to be claimed
     * @param _tokenAddress Token address
     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
     * @param _expiration Unix timestamp of link expiration time
     * @param _linkId Address corresponding to link key
     * @param _signature ECDSA signature of linkdrop signer
     * @return True if signed with linkdrop signer's private key
     */
    function createReferralLink(
        address memberAddress, 
        ReferralCreditType referralCreditType,
        uint _weiAmount,
        address _tokenAddress,
        uint _tokenAmount,
        uint _expiration,
        address _linkId,
        bytes memory _signature        
    ) public returns (bool) {
        /// Deploy a new LinkdropMaster contract (evert time when a new referral link is created)
        LinkdropMastercopy linkdropMaster = new LinkdropMastercopy();
        address LINKDROP_MASTER = address(linkdropMaster);
        linkdropMasters.push(LINKDROP_MASTER);

        /// LinkdropMaster should be able to add new signing keys
        //linkdropMaster.addSigner(address _linkdropSigner);

        /// Creates new link key and verifies its signature
        linkdropMaster.verifyLinkdropSignerSignature(_weiAmount, _tokenAddress, _tokenAmount, _expiration, _linkId, _signature);
    }

    /**
     * @notice - Verification process for a referral link (after a distributed-referral link is used by a new user)
     */
    function verifyReferralLink(
        LinkdropMastercopy _linkdropMaster,
        address _linkId,
        address _receiver,
        bytes memory _signature
    ) public returns (bool) {
        /// Set a deployed-LinkdropMaster contract
        LinkdropMastercopy linkdropMaster = LinkdropMastercopy(_linkdropMaster);

        /// Signs receiver address with link key and verifies this signature onchain
        linkdropMaster.verifyReceiverSignature(_linkId, _receiver, _signature);        
    }


}
