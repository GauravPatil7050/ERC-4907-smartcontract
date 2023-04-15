// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC4907.sol";

contract ERC4907 is ERC721, IERC4907 {
    struct UserInfo 
    {
        address user;   
        uint64 expires; 
    }

    mapping (uint256  => UserInfo) internal _users;

    constructor(string memory name_, string memory symbol_) ERC721("GAURAVTOKEN", "GAP") {}
    
   
    function setUser(uint256 tokenId, address user, uint64 expires) public override virtual{
        require(_isApprovedOrOwner(msg.sender, tokenId), "CALL NOT APPROVED");
        UserInfo storage info =  _users[tokenId];

        

        info.user = user;
        info.expires = expires;
        emit UpdateUser(tokenId, user, expires);
    }


    function userOf(uint256 tokenId) public view override virtual returns(address){
        if (uint256(_users[tokenId].expires) >=  block.timestamp) {
            return  _users[tokenId].user;
        } else {
            return ownerOf(tokenId);
        }
    }

    r 
    function userExpires(uint256 tokenId) public view override virtual returns(uint256){
        if (uint256(_users[tokenId].expires) >=  block.timestamp) {
            return _users[tokenId].expires;
        } else {
            return 115792089237316195423570985008687907853269984665640564039457584007913129639935;
        }
    }

    
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC4907).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override{
        super._beforeTokenTransfer(from, to, tokenId);

        if (from != to && _users[tokenId].user != address(0)) {
            delete _users[tokenId];
            emit UpdateUser(tokenId, address(0), 0);
        }
    }

    function mint(uint256 tokenId) public {
    
        _mint(msg.sender, tokenId);
    }

    function time() public view returns (uint256) {
        return block.timestamp;
    }
} 