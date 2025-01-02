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
    mapping(uint256 => uint[]) public setsMap;
    mapping(uint256 => string) private galleryStylesMap;
    mapping(address => uint[]) private contractStylesMap;
    
    event StyleUpdated(address indexed sender, uint256 styleId );
    event WorkStyleUpdate(address indexed sender, string galleryId, string workId);

    
    constructor(){
        _version = 0;   
        string[] memory initials = new string[](3);
        initials[0] = '.pa g g circle{stroke-dasharray: calc(1px * var(--n, 1) * var(--prmnt-progress, 50)) calc(1px * var(--n, 1) * var(--prmnt-intensity, 50)) !important;} .pa g g{fill:none;animation: calc(1s * var(--prmnt-duration, 12)) ease-in-out infinite r1 normal;transform-origin:320px 320px;animation-delay: calc(-1s * var(--n));}@keyframes r1{0%{transform:rotate(0)}50%{transform:rotate(180deg)}} ';
        initials[1] = '.pa g g circle{filter:drop-shadow(calc(1px * var(--n,4)) 4px 0px var(--c4));}';
        initials[2] = '.pa g g circle{transform-origin: center;  animation: calc(.1s * var(--prmnt-duration, 4)) ease-in-out infinite pulseit normal;animation-delay: calc(0.03s* var(--n)); } @keyframes pulseit{0%{scale:1;}5%{scale:1.15;}10%{scale:0.9;}20%{scale:1.05;}30%{scale:.95;}33%{scale:1.01;}39%{scale:1;}}';
        // t = ['.pa g g circle{stroke-dasharray: calc(1px * var(--n, 1) * var(--prmnt-progress, 50)) calc(1px * var(--n, 1) * var(--prmnt-intensity, 50)) !important;} .pa g g{fill:none;animation: calc(1s * var(--prmnt-duration, 12)) ease-in-out infinite r1 normal;transform-origin:320px 320px;animation-delay: calc(-1s * var(--n));}@keyframes r1{0%{transform:rotate(0)}50%{transform:rotate(180deg)}} ',   '.pa g g circle{transform-origin: center;  animation: calc(1s * var(--prmnt-duration, 4)) ease-in-out infinite pulseit normal;animation-delay: calc(0.1s* var(--n)); } @keyframes pulseit{0%{scale:1;}5%{scale:1.15;}10%{scale:0.9;}20%{scale:1.05;}30%{scale:.95;}33%{scale:1.01;}36%{scale:1;}}'];
        // uint256 styleId = _tokenIdCounter;
        stylesMap[0] = initials[0];
        _tokenIdCounter ++;
        stylesMap[1] = initials[1];
        _tokenIdCounter ++;
        stylesMap[2] = initials[2];
        _tokenIdCounter ++;
        // console.log('_tokenIdCounter', _tokenIdCounter);
        // mintStyles(
        //     msg.sender, 
        //     initials,
        //     0
        //     );
        setsMap[0] = [0, 1];
        
    }


    /**
     * @dev Adds a new Style
     */
    function mintStyle(address contractAddress, string memory styleString ) public  {
        uint256 styleId = _tokenIdCounter;
        stylesMap[styleId] = styleString;
        console.log('Mint: styleId is', styleId);
        contractStylesMap[contractAddress].push(styleId);
        _tokenIdCounter++;
        emit StyleUpdated(msg.sender, styleId);
    }
    
    /**
     * @dev Adds multipleStyles
     */
    function mintStyles(address contractAddress, string[] memory styleStrings, uint setId ) public  {
        uint256 styleId = _tokenIdCounter;
        for(uint i = 0; i < styleStrings.length; i++){
            mintStyle(contractAddress, styleStrings[i]);
            setsMap[setId].push(styleId + i);
        }   

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
     * @dev Gets a set of ids
     */
    function getSetIds(uint setId) view public returns (uint[] memory) {
        return setsMap[setId];
    }
    
    /**
     * @dev Gets a set of ids
     */
    function setSetIds(uint setId, uint[] memory setIdArray) external  {
        setsMap[setId] = setIdArray;
    }
    
    /**
     * @dev Sets the version
     */
    function setVersion(uint _newVersion) external {
        _version = _newVersion;
    }
    

}
