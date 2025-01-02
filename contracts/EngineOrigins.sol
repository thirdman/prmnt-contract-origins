// SPDX-License-Identifier: MIT
/*
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
██ ▄▄ ██ ▄▄▀██ ▄▀▄ ██ ▀██ █▄▄ ▄▄
██ ▀▀ ██ ▀▀▄██ █ █ ██ █ █ ███ ██
██ █████ ██ ██ ███ ██ ██▄ ███ ██
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
*/

pragma solidity ^0.8.24;
import "@thirdweb-dev/contracts/lib/Strings.sol";
// import "solady/src/utils/FixedPointMathLib.sol";
import "hardhat/console.sol";
contract EngineOrigins  {
    uint256 ringCount  = 12;
    string private imageClass  = 'pao';
    address stylesContractAddress;
    // string private variablesPrefix = '--p';
    constructor(
        address  _stylesContractAddress
    ){
        stylesContractAddress = _stylesContractAddress;
    }

    function getExtended() public pure returns (string memory){
        return '.pa g g circle{stroke-dasharray: calc(1px * var(--n, 1) * var(--prmnt-progress, 50)) calc(1px * var(--n, 1) * var(--prmnt-intensity, 50)) !important; } .pa g g{fill:none;animation: calc(1s * var(--prmnt-duration, 12)) ease-in-out infinite r1 normal;transform-origin:320px 320px;animation-delay: calc(-1s * var(--n));}@keyframes r1{0%{transform:rotate(0)}50%{transform:rotate(180deg)}} ';
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function calculateRadius( uint baseRadius, uint256 multiplier, uint256 stroke) internal pure returns (uint256) {
        
        // uint radius = (5 * i * i) / 2;;
        // return (multiplier * offset) * 314 / 100
        
        uint newRadius = (baseRadius * (multiplier * 2));
        // console.log('newRadius', newRadius);
        // uint circumference = newRadius * 2 * 314 / 100;
        // console.log('circumference', newRadius);
        uint halfStrokeWidth = stroke / 2;
        // return (newRadius - halfStrokeWidth) ; //   - halfStrokeWidth
        return (newRadius + halfStrokeWidth) ; //   - halfStrokeWidth
        // return (offset * multiplier * multiplier) / 2;
    }
    function calculateStroke( uint i, uint256 depth, uint256 multiplier) internal pure returns (uint256) {
        uint newStroke = i * depth * multiplier;
        return newStroke ;
    }
    
    function createColor( uint256 hue, uint256 sat, uint256 lightness) internal pure returns (string memory){
        return string.concat("hsl(", Strings.toString(hue), ", ",Strings.toString(sat),"%, ", Strings.toString(lightness), "%)");
    }


    function createArtwork( uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale, uint256 styleId ) public view returns (string memory){
        string memory parts = string.concat(
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMidYMid meet' width='640' height='640' viewBox='0 0 640 640' class='pa' style='background: ",
            createColor(hue, 40, 50),
        "; --p-pulse: 0;'>",
        generatePaths(ringCount, hue, progress, intensity, depth, scale),
        "<style>",getExtended(),"</style>",
        "<style>",IStyles(stylesContractAddress).getStyle(styleId),"</style>",
        '</svg>');
        return parts;
    }
    
    function createArtworkWithTheme( uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale, uint256 duration, string[5] memory colors, uint256 styleId) public view returns (string memory){
        string memory parts = string.concat(
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMidYMid meet' width='640' height='640' viewBox='0 0 640 640' class='pa' style='background: ",
            createColor(hue, 40, 50),
        "; background-color: var(--c4, ",createColor(hue, 40, 50), "); --prmnt-duration:", Strings.toString(duration),";'>",
        generatePaths(ringCount, hue, progress, intensity, depth, scale),
        // generatePaths(ringCount, hue, progress, intensity, 20, 100),
        "<style>", 
        getColorVariables(colors), 
        getExtended(),
        "</style>",
        "<style>",IStyles(stylesContractAddress).getStyle(styleId),"</style>",
        '</svg>');
        return parts;
    }

    function generatePaths(uint count, uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale) private pure returns (string memory) {
        string memory pathItems;
        uint multiplier = 5;
        // uint currentRadius = 1;
        console.log('#####');
        console.log('progress  ', progress);
        console.log('intensity ', intensity);
        console.log('depth     ', depth);
        console.log('scale     ', scale);
        console.log('#####');

        for (uint i = 1; i < count; i++) {
           uint strokeWidth = calculateStroke(i, depth / 10, multiplier);
            uint radius = calculateRadius(i * 2, i, strokeWidth);
            console.log('radius', radius);
            
            pathItems = string.concat(pathItems, 
            "<g style='--n: ", //  class='c'
            Strings.toString(i),
            ";' ><circle stroke-width='",
            //  Strings.toString((depth * i) / 5), 
             Strings.toString(strokeWidth), 
            "' cx='320' cy='320' r='", 
            Strings.toString(radius),
            "' stroke-dashoffset='", 
            Strings.toString(intensity * 1000),
            "' stroke-dasharray='",
                Strings.toString(i * progress * 3),
                " ",
                Strings.toString(i * intensity * 3),
            "' /></g>");
        }
        return string.concat("<g stroke='", createColor(hue, 60, 18), "' fill='none' style='stroke: var(--c0,", createColor(hue, 60, 18), "); transform:scale(calc(", Strings.toString(scale), "/100));transform-origin:center;' >", pathItems, "</g>");
    }  

    /**
     *  @notice               Returns compiled theme style infomration.
     *  @dev             
     *  @param _colors        The tokenId of the NFT to mint.
     */

    function getColorVariables(string[5] memory _colors) public pure returns (string memory colorString){ 
        string memory colorStringPrefix = 'svg.pa{';
        string memory colorStringSuffix = '}';
        for(uint i = 0; i < _colors.length; i++){
            colorString = string.concat(colorString, " --c",Strings.toString(i), ": ", _colors[i],";" );
        }
        return string.concat(colorStringPrefix, colorString, colorStringSuffix);
    }
    // /**
    //  *  @notice               Returns compiled theme style infomration.
    //  *  @dev             
    //  *  @param _colors        The tokenId of the NFT to mint.
    //  */

    // function getThemeString(string[5] memory _colors) public pure returns (string memory styleString){ 
    //     string memory colorStringPrefix = "svg.pa{";
    //     string memory colorStringSuffix = "}";
    //     string memory colorString = "";
    //     string memory classesString = "";
    //     for(uint i = 0; i < _colors.length; i++){
    //         colorString = string.concat(colorString, " --c",Strings.toString(i), ": ", _colors[i],";" );
    //     }
    //     for(uint i = 0; i < _colors.length; i++){
    //         classesString = string.concat(classesString,  " .cf-c",Strings.toString(i), "{fill: var(", _colors[i],", transparent);}");
    //     }
    //     return string.concat(colorStringPrefix, colorString, "} ", classesString, colorStringSuffix);
    // }

}

interface IStyles {
    function getStyle(uint styleId) external pure returns (string memory style );
}