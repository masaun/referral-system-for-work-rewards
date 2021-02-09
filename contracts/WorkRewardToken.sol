pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import { ERC20 } from "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import { ERC20Detailed } from "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import { Ownable } from "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract WorkRewardToken is ERC20, ERC20Detailed, Ownable {
    
    constructor() public ERC20Detailed("Work Reward Token", "WORK", 18) {
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
