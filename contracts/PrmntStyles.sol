// SPDX-License-Identifier: MIT
/*
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
██ ▄▄ ██ ▄▄▀██ ▄▀▄ ██ ▀██ █▄▄ ▄▄
██ ▀▀ ██ ▀▀▄██ █ █ ██ █ █ ███ ██
██ █████ ██ ██ ███ ██ ██▄ ███ ██
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
*/

pragma solidity ^0.8.24;
import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "hardhat/console.sol";

contract PrmntStyles {
    uint256 _version  = 0;
    uint256 private _tokenIdCounter;
    mapping(uint256 => string) private stylesMap;
    mapping(uint256 => string) private galleryStylesMap;
    mapping(address => uint[]) private contractStylesMap;
    
    event StyleUpdated(address indexed sender, uint256 styleId );
    event WorkStyleUpdate(address indexed sender, string galleryId, string workId);

    
    constructor(){
    _version = 0;   
    }


    /**
     * @dev Adds a new Style
     */
    function mintStyle(address contractAddress, string calldata styleString ) external  {
        uint256 styleId = _tokenIdCounter;
        stylesMap[styleId] = styleString;
        console.log('Mint: styleId is', styleId);
        contractStylesMap[contractAddress].push(styleId);
        _tokenIdCounter++;
        emit StyleUpdated(msg.sender, styleId);
    }

    /**
     * @dev updates a single style string;
     */
    function setStyle(uint styleId, string calldata styleString ) external {
        stylesMap[styleId] = styleString;
        emit StyleUpdated(msg.sender, styleId);
    }

    /**
     * @dev Returns a single style string
     */
    function getStyle(uint styleId) view public returns (string memory style) {
        return stylesMap[styleId];
    }

    /**
     * @dev Get a default contract style string
     */
    function getContractStyle(address contractAddress ) external view returns (string memory style)  {
        return stylesMap[contractStylesMap[contractAddress][0]];
    }

    /**
     * @dev Get a single contract style string by index
     */
    function getContractStyleByIndex(address contractAddress, uint index ) external view returns (string memory style)  {
        return stylesMap[contractStylesMap[contractAddress][index]];
    }

    /**
     * @dev Returns alll contract styles
     */
    function getContractStyles(address contractAddress ) external view returns (uint[] memory)  {
        return contractStylesMap[contractAddress];
    }
    /**
     * @dev Adds a single Contract style
     */
    function setContractStyle(address contractAddress, uint styleId) external  {
        contractStylesMap[contractAddress][0] = styleId;
    }
    
    /**
     * @dev Sets the version
     */
    function setVersion(uint _newVersion) external {
        _version = _newVersion;
    }
    

}
