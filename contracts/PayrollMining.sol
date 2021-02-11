pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";
//import { IERC20 } from "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";
import { MemberRegistry } from "./MemberRegistry.sol";
import { WorkRewardToken } from "./WorkRewardToken.sol";


/**
 * @notice - 5M $WORK Rewards are issued per “Payroll Mining Block” to Employee Members, Coalition Members and Stakers. 
 * @notice - Blocks are mined as the Network grows by increments of $50K or 5% in periodic payroll volume, whichever is greater.
 */
contract PayrollMining is Ownable {
    using SafeMath for uint256;

    // struct PoolInfo {
    //     IERC20 lpToken;                 // Address of LP token contract.
    //     uint256 allocPoint;             // How many allocation points assigned to this pool.
    //     uint256 lastRewardBlock;        // Last block number that $WORK distribution occured.
    //     uint256 accWorkPerShare;        // Accumulated $WORK per share, times 1e12. See below.
    // }
    // PoolInfo[] public poolInfo;         // Info of each pool.

    uint256 public workPerBlock;        /// $WORK tokens created per block.
    uint256 public startBlock;          /// The block number at which $WORK distribution starts.
    uint256 public endBlock;            /// The block number at which $WORK distribution ends.
    uint256 public totalAllocPoint = 0; /// Total allocation poitns. Must be the sum of all allocation points in all pools.

    uint256 public lastMinedBlock;               /// Last block number that $WORK distribution occured.
    //uint256 public lastPeriodicPayrollVolume;  /// Periodic payroll volume in the last block

    MemberRegistry public memberRegistry;
    WorkRewardToken public workRewardToken;
    
    constructor(MemberRegistry _memberRegistry, WorkRewardToken _workRewardToken) public {
        memberRegistry = _memberRegistry;
        workRewardToken = _workRewardToken;

        workPerBlock = 5000000 * 1e18;  /// 5M $WORK Rewards are issued per “Payroll Mining Block”
        startBlock = block.number;
    }

    /**
     * @notice - Update "Payroll Mining Block" when specified-condition is fulfilled.
     * @notice - The condition is that the increments of periodic payroll volume is greater than $50K or 5%
     */
    function updateBlock(uint latestPeriodicPayrollVolume) public onlyOwner returns (bool) {
        uint256 latestMinedBlock = block.number;
        uint256 latestPeriodicPayrollVolume = _computeLatestPeriodicPayrollVolume();  /// Periodic payroll volume in the latest block

        uint256 differenceOfVolume = latestPeriodicPayrollVolume.sub(lastPeriodicPayrollVolume);
        uint256 differenceOfPercentage = differenceOfVolume.div(lastPeriodicPayrollVolume);
        uint256 FIVE_K_DOLLAR = 50000 * 1e18; /// $50K
        uint256 FIVE_PERCENT = 5 * 1e18;      /// 5%

        /// [Todo]: Condition in order to judge whether the Block is mined or not
        if (differenceOfVolume > FIVE_K_DOLLAR) {            /// periodic payroll volume is greater than $50K
            _mineBlock();
            _distributeWorkRewards();
        } else if (differenceOfPercentage > FIVE_PERCENT) {  /// periodic payroll volume is greater than 5%
            _mineBlock();
            _distributeWorkRewards();
        }

        /// Update the last periodic payroll volume
        lastPeriodicPayrollVolume = latestPeriodicPayrollVolume;
    }

    /**
     * @notice - Every block (every 15 seconds), the latest periodic payroll volume is computed.
     */
    function _computeLatestPeriodicPayrollVolume() internal returns (uint _latestPeriodicPayrollVolume) {
        uint256 latestPeriodicPayrollVolume;  /// Periodic payroll volume in the latest block
        return latestPeriodicPayrollVolume;
    }

    /**
     * @notice - Mine new block (5M $WORK Rewards are issued per “Payroll Mining Block”)
     */
    function _mineBlock() internal returns (bool) {
        /// [Note]: Executor is only owner
        workRewardToken.mintTo(address(this), workPerBlock);
    }

    /**
     * @notice - Distribute $WORK tokens mined to Employee Members, Coalition Members and Stakers as reward
     */
    function _distributeWorkRewards() internal returns (bool) {
        /// [Note]: Assuming that all receivers are received same $WORK amount, distribution below is executed
        address[] memory allMembers;
        uint totalNumberOfReceivers = memberRegistry.getAllMembers().length;
        uint receivedWorkAmountPerReceiver = workPerBlock.div(totalNumberOfReceivers);

        for (uint r=0; r < totalNumberOfReceivers; r++) {
            address memberAddress = memberRegistry.getAllMembers()[r].memberAddress;
            workRewardToken.transfer(memberAddress, receivedWorkAmountPerReceiver);
        }
    }  

}
