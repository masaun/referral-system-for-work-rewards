pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import { MemberRegistry } from "./MemberRegistry.sol";
import { LinkdropERC20 } from "./linkdrop/linkdrop/LinkdropERC20.sol";


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

    MemberRegistry public memberRegistry;
    LinkdropERC20 public linkdropERC20;

    constructor(MemberRegistry _memberRegistry, LinkdropERC20 _linkdropERC20) public {
        memberRegistry = _memberRegistry;
        linkdropERC20 = _linkdropERC20;
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
        linkdropERC20.verifyLinkdropSignerSignature(_weiAmount, _tokenAddress, _tokenAmount, _expiration, _linkId, _signature);
    }

}
