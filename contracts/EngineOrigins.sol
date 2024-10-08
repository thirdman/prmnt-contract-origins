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

contract EngineOrigins {
    uint256 ringCount  = 12;
    string private imageClass  = 'pao';
    
    function getExtended() public pure returns (string memory){
        return '.pa g g circle{stroke-dasharray: calc(1px * var(--n, 1) * var(--prmnt-progress, 50)) calc(1px * var(--n, 1) * var(--prmnt-intensity, 50)) !important;} .pa g g{fill:none;animation: calc(1s * var(--prmnt-duration, 12)) ease-in-out infinite r1 normal;transform-origin:320px 320px;animation-delay: calc(-1s * var(--n));}@keyframes r1{0%{transform:rotate(0)}50%{transform:rotate(180deg)}}'; // 5px
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function calculateRadius(uint256 multiplier, uint256 offset) internal pure returns (uint256) {
        return (multiplier * offset) * 50 / 10;
    }
    
    function createColor( uint256 hue, uint256 sat, uint256 lightness) internal pure returns (string memory){
        return string.concat("hsl(", Strings.toString(hue), ", ",Strings.toString(sat),"%, ", Strings.toString(lightness), "%)");
    }


    function createArtwork( uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale) public view returns (string memory){
        string memory parts = string.concat(
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMidYMid meet' width='640' height='640' viewBox='0 0 640 640' class='pa' style='background: ",
            createColor(hue, 40, 50),
        ";'>",
        generatePaths(ringCount, hue, progress, intensity, depth, scale),
        "<style>",getExtended(),"</style>",
        '</svg>');
        return parts;
    }
    
    function createArtworkWithTheme( uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale, uint256 duration, string[5] memory colors) public view returns (string memory){
        string memory parts = string.concat(
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMidYMid meet' width='640' height='640' viewBox='0 0 640 640' class='pa' style='background: ",
            createColor(hue, 40, 50),
        "; background-color: var(--c4, ",createColor(hue, 40, 50), "); --prmnt-duration:", Strings.toString(duration),";'>",
        generatePaths(ringCount, hue, progress, intensity, depth, scale),
        "<style>", 
        getColorVariables(colors), 
        getExtended(),
        "</style>",
        '</svg>');
        return parts;
    }

    function generatePaths(uint count, uint256 hue, uint256 progress, uint256 intensity, uint256 depth, uint256 scale) private pure returns (string memory) {
        string memory pathItems;
        for (uint i = 1; i < count; i++) {
            uint radius = (5 * i * i) / 2;
            pathItems = string.concat(pathItems, 
            "<g style='--n: ", //  class='c'
            Strings.toString(i),
            ";' ><circle stroke-width='",
             Strings.toString((depth * i) / 5), 
            "' cx='320' cy='320' r='", 
            Strings.toString(radius * 2),
            "' stroke-dashoffset='", 
            Strings.toString(intensity * 1000),
            "' stroke-dasharray='",
                Strings.toString(i * progress),
                " ",
                Strings.toString(i * intensity),
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
