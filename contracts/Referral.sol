pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import { MemberRegistry } from "./MemberRegistry.sol";
import { LinkdropMastercopy } from "./linkdrop/linkdrop/LinkdropMastercopy.sol";
import { LinkdropFactory } from "./linkdrop/factory/LinkdropFactory.sol";
import { WorkRewardToken } from "./WorkRewardToken.sol";


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

    address[] public linkdropMasters;   /// All deployed-LinkdropMaster contract address are assigned into here
    address[] public linkdropFactories; /// All deployed-LinkdropFactory contract address are assigned into here

    event LinkdropMasterCreated(LinkdropMastercopy linkdropMaster);
    event LinkdropFactoryCreated(LinkdropFactory linkdropFactory);

    MemberRegistry public memberRegistry;
    WorkRewardToken public workRewardToken;

    constructor(MemberRegistry _memberRegistry, WorkRewardToken _workRewardToken) public {
        memberRegistry = _memberRegistry;
        workRewardToken = _workRewardToken;
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

        /// Deploy a new factory (that is associated with a deployed LinkdropMaster contract above)
        address payable _masterCopy = address(uint160(LINKDROP_MASTER));
        uint _chainId = 1612838146832;  /// [Note]: This chain ID (network ID) is development. In case of development chain ID, I need to replace them every time when migrate
        LinkdropFactory linkdropFactory = new LinkdropFactory(_masterCopy, _chainId);
        address LINKDROP_FACTORY = address(linkdropFactory);
        linkdropFactories.push(LINKDROP_FACTORY);

        /// LinkdropMaster should be able to add new signing keys
        //linkdropMaster.addSigner(address _linkdropSigner);

        /// Creates new link key and verifies its signature
        linkdropMaster.verifyLinkdropSignerSignature(_weiAmount, _tokenAddress, _tokenAmount, _expiration, _linkId, _signature);

        emit LinkdropMasterCreated(linkdropMaster);
        emit LinkdropFactoryCreated(linkdropFactory);
    }

    /**
     * @notice - Verification process for a referral link (after a distributed-referral link is used by a new user)
     *
     * @dev Function to verify linkdrop receiver's signature
     * @param _linkId Address corresponding to link key
     * @param _receiver Address of linkdrop receiver
     * @param _signature ECDSA signature of linkdrop receiver
     * @return True if signed with link key
     */
    function verifyReferralLink(
        LinkdropMastercopy _linkdropMaster,
        address _linkId,
        address _receiver,
        bytes memory _signature
    ) public returns (bool) {
        /// Set a deployed-LinkdropMaster contract
        LinkdropMastercopy linkdropMaster = _linkdropMaster;

        /// Signs receiver address with link key and verifies this signature onchain
        linkdropMaster.verifyReceiverSignature(_linkId, _receiver, _signature);        
    }

    /**
     * @notice - Claim link by a creator of used-referral link (and then, they get tokens as referral rewards)
     *
     * @dev Function to claim ETH and/or ERC20 tokens
     * @param _weiAmount Amount of wei to be claimed
     * @param _tokenAddress Token address
     * @param _tokenAmount Amount of tokens to be claimed (in atomic value)
     * @param _expiration Unix timestamp of link expiration time
     * @param _linkId Address corresponding to link key
     * @param _linkdropMaster Address corresponding to linkdrop master key
     * @param _campaignId Campaign id
     * @param _linkdropSignerSignature ECDSA signature of linkdrop signer
     * @param _receiver Address of linkdrop receiver
     * @param _receiverSignature ECDSA signature of linkdrop receiver
     * @return True if success
     */
    function claimLink(
        LinkdropFactory _linkdropFactory,
        uint _weiAmount,
        address _tokenAddress,
        uint _tokenAmount,
        uint _expiration,
        address _linkId,
        address payable _linkdropMaster,
        uint _campaignId,
        bytes memory _linkdropSignerSignature,
        address payable _receiver,
        bytes memory _receiverSignature
    ) public returns (bool) {
        LinkdropFactory linkdropFactory = _linkdropFactory;

        workRewardToken.approve(address(linkdropFactory), _tokenAmount);

        /// Check parameters of the claimed-link in advance
        bool result = linkdropFactory.checkClaimParams(_weiAmount, 
                                                       _tokenAddress,
                                                       _tokenAmount, 
                                                       _expiration, 
                                                       _linkId, 
                                                       _linkdropMaster, 
                                                       _campaignId, 
                                                       _linkdropSignerSignature, 
                                                       _receiver, 
                                                       _receiverSignature);

        require(result == true, "INSUFFICIENT_ALLOWANCE");
        
        /// [Note]: Only link that is not expired link can be claimed
        linkdropFactory.claim(_weiAmount, 
                              _tokenAddress,
                              _tokenAmount, 
                              _expiration, 
                              _linkId, 
                              _linkdropMaster, 
                              _campaignId, 
                              _linkdropSignerSignature, 
                              _receiver, 
                              _receiverSignature);
    }
}
