pragma solidity ^0.5.16;

import { ERC721Full } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract ReferralNFT is ERC721Full {
    using SafeMath for uint;

    uint public currentTokenId;

    constructor() public ERC721Full("Referral NFT", "RNFT") {}

    function mintTo(address to) public returns (bool) {
        uint newTokenId = getNextTokenId();
        currentTokenId++;
        _mint(to, newTokenId);
        _setTokenURI(newTokenId, "https://referral.opolis.co/1dhwd6");  /// [Note]: This URI is just a exapmle
    }


    ///---------------------
    /// Getter methods
    ///---------------------    
    function getNextTokenId() private view returns (uint _newTokenId) {
        return currentTokenId.add(1);
    }
    
}
