// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Gift1155 is ERC1155 {
    uint256 private _currentGiftId = 0;
    bool public isUsed;
    mapping(uint256 => string) public giftNames;
    mapping(uint256 => address) public giftRecipients;
    mapping(uint256 => uint256) public giftMintedAt;

    event Minted(address indexed recipient, uint256 indexed tokenId);
    event Burned(address indexed owner, uint256 indexed tokenId);

    constructor() ERC1155("https://yourdomain.com/api/gift/{id}.json") {}
    function mintGift(
        address recipient,
        uint256 amount,
        string memory name,
        bytes memory data
    ) external {
        uint256 giftId = _currentGiftId++;
        _mint(recipient, giftId, amount, data);
        giftNames[giftId] = name;
        giftRecipients[giftId] = recipient;
        giftMintedAt[giftId] = block.timestamp;

        emit Minted(recipient, giftId);
    }

    function isExpired(uint256 tokenId) public view returns (bool) {
        uint256 mintedAt = giftMintedAt[tokenId];
        require(mintedAt > 0, "Token does not exist");
        return block.timestamp > mintedAt + 7 days;
    }

    function uri(uint256 giftId) public view override returns (string memory) {
        return string(abi.encodePacked(super.uri(giftId)));
    }

    function getGiftInfo(
        uint256 giftId
    ) external view returns (string memory name, address recipient) {
        return (giftNames[giftId], giftRecipients[giftId]);
    }

    function burn(uint256 tokenId) external {
        require(isUsed, "expired");
        uint256 balance = balanceOf(msg.sender, tokenId);
        require(balance > 0, "You don't own this token");
        _burn(msg.sender, tokenId, balance);

        delete giftNames[tokenId];
        delete giftRecipients[tokenId];

        emit Burned(msg.sender, tokenId);
    }

}
