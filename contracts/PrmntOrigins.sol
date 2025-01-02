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
import "base64-sol/base64.sol";
import "./EngineOrigins.sol";
import "hardhat/console.sol";

contract PrmntOrigins is ERC721Base, EngineOrigins {
    uint256 public mintFee;
    uint256 public generation;
    uint256 public moduleId;
    uint256 public defaultContrast;
    uint256 public defaultSaturation;
    uint256 public defaultScale;
    uint256 public defaultStyleId;
    // address[] public validContracts;
    // address stylesContractAddress;
    string public galleryDataBase = "https://arweave.net/";
    string public baseUri = "https://origins.prmnt.art/origin/";
    mapping (uint256 => Attributes) public tokenAttributes;    
    mapping (uint256 => StyleAttributes) public tokenStyles;    
    mapping (uint256 => uint256) public tokenHueToId;
    mapping (uint256 => string) public tokenIdToGallery;
    mapping (uint256 => uint256) public tokenIdToContrast;
    mapping (uint256 => uint256) public tokenIdToScale;
    mapping (uint256 => uint256) public tokenIdToSat;
    mapping (uint256 => uint256) public tokenIdToStyleId;
    // mapping (uint256 => uint256) public tokenIdToStyleId;
    mapping (uint256 => bool) public isAnimatedMap;
    mapping (uint256 => string) public modeMap;
    
    EngineOrigins public descriptor;

    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _stylesAddress,
        address  _whitelistAddress // this is an empty test field
        
        ) EngineOrigins(_stylesAddress) ERC721Base (
            _defaultAdmin,
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
            ) {        
        mintFee = 5000000000000000; // 0.005 eth
        descriptor = new EngineOrigins(_stylesAddress);
        generation = 0;
        stylesContractAddress = _stylesAddress;
        moduleId = 0;
        defaultContrast = 40;
        defaultSaturation = 40;
        defaultScale = 100;
        defaultStyleId = 2;
    }
    event TokenUpdate(address indexed sender, uint256 tokenId );
    error Unauthorized();
    
    
    function claimRandom() external  {
        uint256 tokenId = nextTokenIdToMint();
        uint hue = getUnusedHue(tokenId);                       // uses token id as seed
        uint tempScale = randomInRange(40, 290, tokenId * 100); // entropy value helps differntiate
        // tokenAttributes[tokenId] = Attributes({
        //     hue: hue,
        //     duration: randomInRange(20, 70, tokenId * 200), 
        //     intensity: randomInRange(1, 200, tokenId * 300),
        //     progress: randomInRange(10, 100, tokenId * 400),
        //     depth: randomInRange(5, 100, tokenId * 500),
        //     scale: tempScale
        // });
        // tokenStyles[tokenId] =  StyleAttributes(
        //     randomInRange(20, 60, tokenId * 600), 
        //     randomInRange(15, 95, tokenId * 700), 
        //     defaultStyleId, 
        //     true
        // );
        // setTokenStyle(tokenId, 
        //     randomInRange(20, 60, tokenId * 600), 
        //     randomInRange(15, 95, tokenId * 700), 
        //     defaultStyleId, 
        //     true
        // );
        setTokenData(tokenId, Attributes({
            hue: hue,
            duration: randomInRange(20, 70, tokenId * 200), 
            intensity: randomInRange(1, 200, tokenId * 300),
            progress: randomInRange(10, 100, tokenId * 400),
            depth: randomInRange(5, 100, tokenId * 500),
            scale: tempScale
        }), StyleAttributes(randomInRange(20, 60, tokenId * 600), 
            randomInRange(15, 95, tokenId * 700), 
            defaultStyleId, 
            true));

        // tokenHueToId[hue] = tokenId;
        // tokenIdToContrast[tokenId] = randomInRange(20, 60, tokenId * 600);
        // tokenIdToSat[tokenId] = randomInRange(15, 95, tokenId * 700);
        // tokenIdToScale[tokenId] = tempScale;
        // tokenIdToStyleId[tokenId] = defaultStyleId;
        // isAnimatedMap[tokenId] = true;
        _safeMint(msg.sender, 1);
        emit TokenUpdate(msg.sender, tokenId);
    }

    
    function claim(uint256 hue, uint256 _duration, uint256 _intensity , uint256 _progress, uint256 _depth ) external payable { //uint256 tokenId, uint256 _amount
        if (hue < 0 || hue > 359 || tokenHueToId[hue] > 0) revert Unauthorized();
        uint256 tokenId = nextTokenIdToMint();
        // tokenAttributes[tokenId] = Attributes({
        //     hue: hue,
        //     duration: _duration, 
        //     intensity: _intensity,
        //     progress: _progress,
        //     depth: _depth,
        //     scale: defaultScale
        // });
        // setTokenStyle(tokenId, defaultContrast, defaultSaturation, defaultStyleId, true);
        setTokenData(tokenId, Attributes({
            hue: hue,
            duration: _duration, 
            intensity: _intensity,
            progress: _progress,
            depth: _depth,
            scale: defaultScale
        }), StyleAttributes(defaultContrast, defaultSaturation, defaultStyleId, true));
        // tokenHueToId[hue] = tokenId;
        // tokenIdToContrast[tokenId] = defaultContrast;
        // tokenIdToSat[tokenId] = defaultSaturation;
        // tokenIdToScale[tokenId] = defaultScale;
        // tokenIdToStyleId[tokenId] = defaultStyleId;
        // isAnimatedMap[tokenId] = true;
        _safeMint(msg.sender, 1);
        emit TokenUpdate(msg.sender, tokenId);
    }

    

    
    /**
     * @dev Public method to get token attributes
     */
    function getAttributes(uint256 tokenId) external view returns (Attributes memory){
        return tokenAttributes[tokenId];
        // return  ExtendedAttributes(
        // tokenAttributes[tokenId].hue,
        // tokenAttributes[tokenId].duration,
        // tokenAttributes[tokenId].intensity,
        // tokenAttributes[tokenId].progress,
        // tokenAttributes[tokenId].depth,
        // tokenAttributes[tokenId].scale,
        // tokenIdToStyleId[tokenId]    
        // );
    }

    /**
     * @dev External facing function to update token attribites
     * @notice Should only work if the sender is the token owner.
     */
    function setAttributes(uint256 tokenId,  uint256 _duration,   uint256 _intensity, uint256 _progress, uint256 _depth, uint256 _scale  ) external {
        if (msg.sender != ownerOf(tokenId)) revert Unauthorized();
        tokenAttributes[tokenId] = Attributes({
            hue: tokenAttributes[tokenId].hue,
            duration: _duration, 
            intensity: _intensity,
            progress: _progress,
            depth: _depth,
            scale: _scale
        });
    }

    /**
     * @dev Internal method to create all Attributes
     */
    function setTokenData(uint256 tokenId,  Attributes memory _attributes, StyleAttributes memory _styleAttributes  ) internal {
        tokenAttributes[tokenId] =  _attributes;
        tokenStyles[tokenId] =  _styleAttributes;
    }

    /**
     * @dev Returns the base uri if exists, else the compiled URI
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string.concat('data:application/json;base64,', 
            Base64.encode(
                abi.encodePacked(
                    '{"description": "Limited edition dynamic on-chain image. The expression of this work is controlled by the owner settings of Theme, Intensity, Duration, Progress, and Depth. ", "name": "Origins Hue ', 
                    Strings.toString(tokenAttributes[tokenId].hue), 
                    '/360", ', 
                    '"external_url": "', baseUri, Strings.toString(tokenId), '" , ', 
                    getAttributesString(tokenId),
                    ', "image": "data:image/svg+xml;base64,', 
                        Base64.encode(
                            bytes(getImage(tokenId))
                        ),
                    '"}'
                )
            )
        );
    }

    /* 
    Returns attribtues string for ease of use
    */
    function getAttributesString(uint tokenId) internal view returns (string memory){
        return string.concat('"attributes": [{"trait_type": "Hue", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].hue),
                        '"}, {"trait_type": "Duration", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].duration),
                        '"}, {"trait_type": "Intensity", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].intensity),
                        '"}, {"trait_type": "Progress", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].progress),
                        '"}, {"trait_type": "Depth", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].depth),
                        '"}, {"trait_type": "Scale", "value": "', 
                        Strings.toString(tokenAttributes[tokenId].scale),
                        // '"}, {"trait_type": "Animated", "value": "', 
                        // isAnimatedMap[tokenId] ? 'Yes' : 'No',
                        // '"}, {"trait_type": "Items", "value": "', 
                        // Strings.toString(itemsMap[tokenId].length),
                        '"}]');
    }
   

    /**
     * @dev Returns the base64 string
     */
    function getBase64Image(uint256 tokenId) public view returns (string memory ){
        return string.concat('data:image/svg+xml;base64,', Base64.encode(bytes(getImage(tokenId))));
    }
    
    /**
     * @dev Returns the PRMNT art value
     */
    function getArt(uint256 tokenId) public view returns (string memory ){
        return createArtwork( tokenAttributes[tokenId].hue, tokenAttributes[tokenId].progress, tokenAttributes[tokenId].intensity, tokenAttributes[tokenId].depth, tokenAttributes[tokenId].scale, tokenStyles[tokenId].styleId);
    }
    
    /**
     * @dev Returns the PRMNT art value. falls abck to the get iamge
     */
    function getScene(uint256 tokenId) public view returns (string memory ){
        return getImage(tokenId);
    }

    /**
     * @dev Returns the Origins image string
     */
    function getImage(uint256 tokenId) public view returns (string memory ){
        return createArtworkWithTheme( tokenAttributes[tokenId].hue, tokenAttributes[tokenId].progress, tokenAttributes[tokenId].intensity, tokenAttributes[tokenId].depth, tokenAttributes[tokenId].scale, tokenAttributes[tokenId].duration, getThemeColors(tokenId), tokenStyles[tokenId].styleId);
    }
    
    /**
     * @dev Returns bool true if the image is animated
     */
    function setIsAnimated(uint256 tokenId, bool newState) external onlyOwner returns (bool ){   
        return isAnimatedMap[tokenId] = newState;
    }

    /**
     * @dev Returns bool true if the image is animated
     */
    function getIsAnimated(uint256 tokenId) public view returns (bool ){   
        return isAnimatedMap[tokenId];
    }

    
    /**
     * SET THEME ATTRIBUTES
     * @dev creates a theme array based on supplied params. Unrelated to token
     * @param tokenId relevant tokenId
     * @param _saturation saturation value between 0 and 100. Default is 40
     * @param _contrast contrast value between 0 and 100, where 0 makes every color the same, and 100 is max between white and black;
     */
    
    function setThemeAttributes(uint256 tokenId, uint _saturation, uint _contrast) external{   
        if (msg.sender != ownerOf(tokenId)) revert Unauthorized();
        tokenStyles[tokenId].saturation = _saturation;
        tokenStyles[tokenId].contrast = _contrast;
    }

    /**
     * @dev Sets the token style id.
     */
    function setTokenStyle(uint256 tokenId, uint _styleId ) internal {
        if (msg.sender != ownerOf(tokenId)) revert Unauthorized();
        tokenStyles[tokenId].saturation = _styleId;
    }

    /**
     * CREATE THEME VALUES
     * @dev creates a theme array based on supplied params. Unrelated to token
     * @param hue number between 0 and 360
     * @param sat saturation value between 0 and 100. Default is 40
     * @param contrast contrast value between 0 and 100, where 0 makes every color the same, and 100 is max between white and black;
     */
    
    function createThemeValues(uint256 hue, uint sat, uint contrast) public pure returns (Theme memory theme ){   
        theme.colors = createThemeColors(hue, sat, contrast);
        theme.name = "Custom Theme";
        theme.hue = hue;
        theme.contrast = contrast;
        theme.sat = sat;
        return theme;
    }
    /**
     * GET THEME
     * @dev creates a theme array based on current token attributes
     * @param tokenId the relevant token
     */
    
    function getTheme(uint256 tokenId) public view returns (Theme memory theme ){   
        uint themeHue = tokenAttributes[tokenId].hue;
        uint sat = tokenIdToSat[tokenId];
        uint contrast = tokenIdToContrast[tokenId];
        theme.colors = getThemeColors(tokenId);
        theme.name = "Origins Theme";
        theme.hue = themeHue;
        theme.sat = sat;
        theme.contrast = contrast;
        return theme;
    }

    /**
     * GET THEME COLORS
     * @dev creates a theme array based on current token attributes
     * @param tokenId the relevant token id to create theme for. This defines the base hue.
     */
    function getThemeColors(uint256 tokenId) public view returns (string[5] memory themeColors ){   
        uint themeHue = tokenAttributes[tokenId].hue;
        uint sat = tokenStyles[tokenId].saturation;
        uint contrast = tokenStyles[tokenId].contrast;
        themeColors = createThemeColors(themeHue, sat, contrast);
        return themeColors;
    }
   
    /**
     * CREATE THEME COLORS
     * @dev helper function to create color array
     * @param hue number between 0 and 360
     * @param sat saturation value between 0 and 100. Default is 40
     * @param contrast contrast value between 0 and 100, where 0 makes every color the same, and 100 is max between white and black;
     */
    function createThemeColors(uint256 hue, uint sat, uint contrast) internal pure returns (string[5] memory themeColors ){   
        themeColors[0] = createColor(hue, sat, 50 - contrast / 3);
        themeColors[1] = createColor(hue + 4 , sat, 50 - contrast / 5);
        themeColors[2] = createColor(hue + 8, sat, 50);
        themeColors[3] = createColor(hue + 12, sat, 50 + contrast / 5);
        themeColors[4] = createColor(hue + 16, sat, 50 + contrast / 3);
        return themeColors;
    }
    
    /**
     * @dev Returns name of theme
     */
    function getThemeName(uint256 tokenId) public view returns (string memory name ){   
        return getTheme(tokenId).name;
    }
    
    function getColor(uint256 tokenId, uint index) public view returns (string memory ){   
        return getThemeColors(tokenId)[index];
    }


    
    /**
     * @dev Sets the display mode for a gallery
     */
    // function setGallerySettings(uint256 tokenId, GallerySettings memory newSettings) external{
    //     gallerySettingsMap[tokenId] = newSettings;
    //     emit TokenUpdate(msg.sender, tokenId);
    // }

    /**
     * @dev Gets the gallery settings
     */
    // function getGallerySettings(uint256 tokenId) external view returns (GallerySettings memory gallerySettings){
    //     return gallerySettingsMap[tokenId];
    // }


    // function getGalleryItems(uint256 tokenId) public view returns (WorkItem[] memory){
    //     return itemsMap[tokenId];
    // }
    
    /**
     * @dev Returns arrat of svg owned by the token
     */
    // function getGalleryArtworks(uint256 tokenId) public pure returns (string[] memory artworks){
    //     artworks[0] = '<svg>test0</svg>';
    //     artworks[1] = '<svg>test1</svg>';
    //     artworks[2] = '<svg>test2</svg>';
    //     return artworks;
    // }
    
    /**
     *  Get Fragment Contract Addresses
     */
    // function getFragmentContracts() public view returns (address[] memory){
    //     return validContracts;
    // }

    /**
     *  Add Fragment Contract Address
     */
    // function addFragmentContract(address newAddress) public onlyOwner {
    //     // validContracts[validContracts.length + 1] = newAddress;
    //     validContracts.push(newAddress);
    // }
    

    


    /**
     * TEMP. 
     */
    function setTokenHue(uint tokenId, uint hue) public {
        tokenHueToId[tokenId] = hue;
    }

    /**
     *  get unusedHue
     */
    function getUnusedHue(uint seed) public view returns (uint hueValue){
        uint tempValue;
        uint8 i = 0; 
        while(i < 360){
            tempValue = randomInRange(0, 359, seed + i * 1000);
            console.log('tempValue', tempValue);
            if (tokenHueToId[tempValue] == 0){
                return tempValue;
            }
            i++;
        } 
    }
    /**
     * 
     * @param min : lowest uint
     * @param max : highst uint 
     * @param entropy : value that allows for new seed
     */

    function randomInRange(uint min, uint max, uint entropy) internal pure returns (uint256) {
        uint randomness =  uint256(keccak256(abi.encodePacked(entropy)));
        uint value = randomness % (max - min) + min;
        return value;
    }
    /**
     *  Return style data
     */
    function getItemStyle(uint styleId) public view returns (string memory style){
        return IStyles(stylesContractAddress).getStyle(styleId);
    }

    /**
     *  Update Styles Contract Address
     */
    function getStyleContract() public view onlyOwner returns ( address ) {
        return stylesContractAddress;
    }
    
    /**
     *  Update Styles Contract Address
     */
    function setStyleContract(address newAddress) public onlyOwner {
        stylesContractAddress = newAddress;
    }
    /**
     *  Update Base Uri
     */
    function setUri(string memory newUri) public onlyOwner {
        baseUri = newUri;
    }
    /**
     *  Set fee
     */
    function setFee(uint newFee) public onlyOwner {
        mintFee = newFee;
    }
   
    /**
     *  Withdraw Funds
     */
    function withdraw(address payable recipientAddress) public onlyOwner {
        recipientAddress.transfer(address(this).balance);
    }
}

struct Attributes {
        uint256 hue;
        uint256 duration;
        uint256 intensity;
        uint256 progress;
        uint256 depth;
        uint256 scale;
    }
struct StyleAttributes {
        uint256 contrast;
        uint256 saturation;
        uint256 styleId;
        bool isAnimated;
    }
struct ExtendedAttributes {
        uint256 hue;
        uint256 duration;
        uint256 intensity;
        uint256 progress;
        uint256 depth;
        uint256 scale;
        uint256 style;
    }

struct GallerySettings {
        string mode;
        uint256 duration;
        uint256 theme;
    }


struct Theme {
        uint hue;
        uint sat;
        uint contrast;
        string name;
        string[5] colors;
    }


// interface IStyles {
//     function getStyle(uint styleId) external pure returns (string memory style );
// }