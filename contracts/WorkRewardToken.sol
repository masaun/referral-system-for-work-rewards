pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract WorkRewardToken is ERC20, Ownable {
    
    constructor() public ERC20("Work Reward Token", "WORK") {
        uint initialSupply = 1e8 * 1e18;           /// Initial Supply amount is 100M
        address initialTokenHolder = msg.sender;   /// Deployer address
        _mint(initialTokenHolder, initialSupply);  /// Deployer has 100M $WORK at first as initial supply
    }

    /**
     * @notice - Mint $WORK tokens. (Only owner address can mint)
     */
    function mintTo(address to, uint mintAmount) public onlyOwner returns (bool) {
        _mint(to, mintAmount);
    }

}
