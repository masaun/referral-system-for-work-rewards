pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WorkToken is ERC20 {
    
    constructor() public ERC20("Work Token", "WORK") {}    

}
