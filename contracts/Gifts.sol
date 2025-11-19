// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract Gift1155 is ERC1155 {
    uint256 private _currentGiftId = 0;
    

    mapping(uint256 => string) public giftNames;
    mapping(uint256 => address) public giftRecipients;

    constructor() ERC1155("https://yourdomain.com/api/gift/{id}.json") {}

    function mintGift(address recipient, uint256 amount, string memory name, bytes memory data) external  {
        uint256 giftId = _currentGiftId++;
        _mint(recipient, giftId, amount, data);
        giftNames[giftId] = name;
        giftRecipients[giftId] = recipient;
    }

    function uri(uint256 giftId) public view override returns (string memory) {
        return string(abi.encodePacked(super.uri(giftId)));
    }

    function getGiftInfo(uint256 giftId) external view returns (string memory name, address recipient) {
        return (giftNames[giftId], giftRecipients[giftId]);
    }

    function burn(uint256 tokenId) external {
        require(balanceOf(msg.sender, tokenId) > 0, "No token to burn");
        _burn(msg.sender, tokenId, 1);

        // Limpieza opcional
        delete giftNames[tokenId];
        delete giftRecipients[tokenId];
    }

}
