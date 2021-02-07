pragma solidity ^0.6.12;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
//import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";

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

    uint256 public lastMinedBlock;             /// Last block number that $WORK distribution occured.
    uint256 public lastPeriodicPayrollVolume;  /// Periodic payroll volume in the last block

    WorkRewardToken public workRewardToken;
    
    constructor(WorkRewardToken _workRewardToken) public {
        workRewardToken = _workRewardToken;

        workPerBlock = 5000000;         /// 5M $WORK Rewards are issued per “Payroll Mining Block”
        startBlock = block.number;
    }

    /**
     * @notice - Update "Payroll Mining Block" when specified-condition is fulfilled.
     * @notice - The condition is that the increments of periodic payroll volume is greater than $50K or 5%
     */
    function updateBlock() public returns (bool) {
        uint256 latestMinedBlock = block.number;
        uint256 latestPeriodicPayrollVolume = _computeLatestPeriodicPayrollVolume();  /// Periodic payroll volume in the latest block

        uint256 differenceOfVolume = latestPeriodicPayrollVolume.sub(lastPeriodicPayrollVolume);
        uint256 differenceOfPercentage = differenceOfVolume.div(lastPeriodicPayrollVolume);
        uint256 FIVE_PERCENT = 5 * 1e18;

        /// [Todo]: Condition in order to judge whether the Block is mined or not
        if (differenceOfVolume > 50000) {  /// periodic payroll volume is greater than $50K
            _mineBlock();
        } else if (differenceOfPercentage > FIVE_PERCENT) {  /// periodic payroll volume is greater than 5%
            _mineBlock();
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
     * @notice - Every block (every 15 seconds), the latest periodic payroll volume is computed.
     */
    function _mineBlock() internal returns (bool) {
        /// [Todo]:
    }    

}
