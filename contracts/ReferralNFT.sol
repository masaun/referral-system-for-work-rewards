pragma solidity ^0.5.16;

import { ERC721Metadata } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";
import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract ReferralNFT is ERC721Metadata {
    using SafeMath for uint;

    uint currentTokenId;

    constructor() public ERC721Metadata ("Referral NFT", "RNFT") {}

    function mintTo(address to) public returns (bool) {
        uint newTokenId = getNextTokenId();
        currentTokenId++;
        super._mint(to, newTokenId);
        super._setTokenURI(newTokenId, "https://api.myjson.com/bins/1dhwd6");
    }
    
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);


    ///---------------------
    /// Getter methods
    ///---------------------
    function getNextTokenId() private view returns (uint _newTokenId) {
        return currentTokenId.add(1);
    }
    
}
