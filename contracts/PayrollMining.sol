pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @notice - 5M $WORK Rewards are issued per “Payroll Mining Block” to Employee Members, Coalition Members and Stakers. 
 * @notice - Blocks are mined as the Network grows by increments of $50K or 5% in periodic payroll volume, whichever is greater.
 */
contract PayrollMining is Ownable {

    uint256 public workPerBlock;        /// $WORK tokens created per block.
    uint256 public startBlock;          /// The block number at which $WORK distribution starts.
    uint256 public endBlock;            /// The block number at which $WORK distribution ends.
    uint256 public totalAllocPoint = 0; /// Total allocation poitns. Must be the sum of all allocation points in all pools.
    
    constructor() public {
        workPerBlock = 5000000;         /// 5M $WORK Rewards are issued per “Payroll Mining Block”
        startBlock = block.number;
    }


    
}
