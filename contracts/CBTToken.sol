// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract BlackList is Ownable {
    mapping(address => bool) private _blacklist;

    event BlacklistUpdated(address indexed user, bool value);

    function isBlackListed(address user) public view returns (bool) {
        return _blacklist[user];
    }

    function updateBlacklist(address user, bool value) external onlyOwner {
        _blacklist[user] = value;
        emit BlacklistUpdated(user, value);
    }
}

contract CBTToken is ERC20, BlackList {
    constructor() ERC20("Crypto Bank Token", "CBT") {
        _mint(_msgSender(), 770e9 ether);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal view override(ERC20) {
        require(amount > 0, "Cannot transfer zero tokens");
        require(!isBlackListed(from), "Sender is on blacklist");
        require(!isBlackListed(to), "Receiver is on blacklist");
    }
}
