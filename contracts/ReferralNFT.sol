pragma solidity ^0.5.1;

import { ERC721Metadata } from "openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol";


contract ReferralNFT is ERC721Metadata {

    // Mint 10 NFTs to deployer
    constructor() public ERC721Metadata ("Referral NFT", "RNFT") {
        for (uint i = 0; i < 10; i++) {
            super._mint(msg.sender, i);
            super._setTokenURI(i, "https://api.myjson.com/bins/1dhwd6");
        }

        for (uint i = 11; i < 15; i++) {
            super._mint(address(this), i);
            super._setTokenURI(i, "https://api.myjson.com/bins/1dhwd6");
        }
    }
    
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}
