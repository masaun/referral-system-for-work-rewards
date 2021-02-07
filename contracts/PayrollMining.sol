pragma solidity ^0.6.12;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
//import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { WorkRewardToken } from "./WorkRewardToken.sol";


/**
 * @notice - 5M $WORK Rewards are issued per “Payroll Mining Block” to Employee Members, Coalition Members and Stakers. 
 * @notice - Blocks are mined as the Network grows by increments of $50K or 5% in periodic payroll volume, whichever is greater.
 */
contract PayrollMining is Ownable {

    uint256 public workPerBlock;        /// $WORK tokens created per block.
    uint256 public startBlock;          /// The block number at which $WORK distribution starts.
    uint256 public endBlock;            /// The block number at which $WORK distribution ends.
    uint256 public totalAllocPoint = 0; /// Total allocation poitns. Must be the sum of all allocation points in all pools.

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
    function mineBlock() public returns (bool) {
        uint256 latestBlockNumber = block.number;
        uint256 latestPeriodicPayrollVolume;  /// Periodic payroll volume in the latest block


    }
    
}
