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

contract PrmntOrigins is ERC721Base, EngineOrigins {
    uint256 public mintFee;
    uint256 public generation;
    uint256 public moduleId;
    uint256 public defaultContrast;
    uint256 public defaultSaturation;
    uint256 public defaultScale;
    address[] public validContracts;
    address stylesContractAddress;
    string public galleryDataBase = "https://arweave.net/";
    string public baseUri = "https://origins.prmnt.art/origin/";
    mapping (uint256 => Attributes) public tokenAttributes;    
    mapping (uint256 => uint256) public tokenHueToId;
    mapping (uint256 => string) public tokenIdToGallery;
    mapping (uint256 => uint256) public tokenIdToContrast;
    mapping (uint256 => uint256) public tokenIdToScale;
    mapping (uint256 => uint256) public tokenIdToSat;
    mapping (uint256 => bool) public isAnimatedMap;
    mapping (uint256 => WorkItem[]) public itemsMap;
    mapping (uint256 => string) public modeMap;
    mapping (uint256 => GallerySettings) public gallerySettingsMap;
    mapping(uint256 => mapping(string => string)) private itemSettingsMap;
    EngineOrigins public descriptor;

    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address  _whitelistAddress
        
        ) ERC721Base (
            _defaultAdmin,
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
            ) {        
        mintFee = 5000000000000000; // 0.005 eth
        descriptor = new EngineOrigins();
        generation = 0;
        moduleId = 0;
        defaultContrast = 60;
        defaultSaturation = 40;
        defaultScale = 100;
    }
    event GalleryUpdate(address indexed sender, uint256 tokenId );
    event WorkUpdate(address indexed sender, uint256 tokenId, WorkItem item);
    error Unauthorized();
    function claim(uint256 hue, uint256 _duration, uint256 _intensity , uint256 _progress, uint256 _depth ) external payable { //uint256 tokenId, uint256 _amount
        if (hue < 0 || hue > 359 || tokenHueToId[hue] > 0) revert Unauthorized();
        uint256 tokenId = nextTokenIdToMint();
        tokenAttributes[tokenId] = Attributes({
            hue: hue,
            duration: _duration, 
            intensity: _intensity,
            progress: _progress,
            depth: _depth,
            scale: defaultScale
        });
        tokenHueToId[hue] = tokenId;
        tokenIdToContrast[tokenId] = defaultContrast;
        tokenIdToSat[tokenId] = defaultSaturation;
        tokenIdToScale[tokenId] = defaultScale;
        isAnimatedMap[tokenId] = true;
        // if(works.length > 0){
            // itemsMap[tokenId] = works;
            // emit WorkUpdate(msg.sender, tokenId, works[works.length - 1]);
        // } else {
            // itemsMap[tokenId].push(string.concat(Strings.toString(block.chainid),':',Strings.toHexStringChecksummed(address(this)),':', Strings.toString(tokenId))); 
        // }
        _safeMint(msg.sender, 1);
        emit GalleryUpdate(msg.sender, tokenId);
    }

    

    /**
     * @dev Public method to get token attributes
     */
    function getAttributes(uint256 tokenId) external view returns (Attributes memory){
        return tokenAttributes[tokenId];
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
     * @dev Returns the base uri if exists, else the compiled URI
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string.concat('data:application/json;base64,', 
            Base64.encode(
                abi.encodePacked(
                    '{"description": "Limited edition dynamic on-chain gallery. The expression of this work is controlled by the owner settings of Intensity, Duration, Progress, and Depth. ", "name": "PRMNT Origins Hue ', 
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
     * @dev Returns the Origins image string
     */
    function getImage(uint256 tokenId) public view returns (string memory ){
        return createArtwork( tokenAttributes[tokenId].hue, tokenAttributes[tokenId].progress, tokenAttributes[tokenId].intensity, tokenAttributes[tokenId].depth, defaultScale);
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
     * @param sat saturation value between 0 and 100. Default is 40
     * @param contrast contrast value between 0 and 100, where 0 makes every color the same, and 100 is max between white and black;
     */
    
    function setThemeAttributes(uint256 tokenId, uint sat, uint contrast) external{   
        if (msg.sender != ownerOf(tokenId)) revert Unauthorized();
        tokenIdToSat[tokenId] = sat;
        tokenIdToContrast[tokenId] = contrast;
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
        uint sat = defaultSaturation;
        uint contrast = tokenIdToSat[tokenId];
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
        themeColors[0] = createColor(hue, sat, 50 - contrast / 2);
        themeColors[1] = createColor(hue, sat, 50 - contrast / 4);
        themeColors[2] = createColor(hue, sat, contrast);
        themeColors[3] = createColor(hue, sat, 50 + contrast / 2);
        themeColors[4] = createColor(hue, sat, 50 + contrast / 4);
        return themeColors;
    }
    
    /**
     * @dev Returns bool true if the image is animated
     */
    function getThemeName(uint256 tokenId) public view returns (string memory name ){   
        return getTheme(tokenId).name;
    }
    
    function getColor(uint256 tokenId, uint index) public view returns (string memory ){   
        return getThemeColors(tokenId)[index];
    }


    /**
     * @dev Adds a single items string
     */
    function addItem(uint tokenId, address contractAddress  ) external  { //onlyOwner
        itemsMap[tokenId].push(WorkItem(tokenId, contractAddress)); 
        emit WorkUpdate(msg.sender, tokenId, WorkItem(tokenId, contractAddress));
    }
    
    /**
     * @dev Sets the display mode for a gallery
     */
    function setGallerySettings(uint256 tokenId, GallerySettings memory newSettings) external{
        gallerySettingsMap[tokenId] = newSettings;
        emit GalleryUpdate(msg.sender, tokenId);
    }

    /**
     * @dev Gets the gallery settings
     */
    function getGallerySettings(uint256 tokenId) external view returns (GallerySettings memory gallerySettings){
        return gallerySettingsMap[tokenId];
    }


    function getGalleryItems(uint256 tokenId) public view returns (WorkItem[] memory){
        return itemsMap[tokenId];
    }
    
    /**
     * @dev Returns arrat of svg owned by the token
     */
    function getGalleryArtworks(uint256 tokenId) public pure returns (string[] memory artworks){
        artworks[0] = '<svg>test0</svg>';
        artworks[1] = '<svg>test1</svg>';
        artworks[2] = '<svg>test2</svg>';
        return artworks;
    }
    
    /**
     *  Get Fragment Contract Addresses
     */
    function getFragmentContracts() public view returns (address[] memory){
        return validContracts;
    }

    /**
     *  Add Fragment Contract Address
     */
    function addFragmentContract(address newAddress) public onlyOwner {
        // validContracts[validContracts.length + 1] = newAddress;
        validContracts.push(newAddress);
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

struct GallerySettings {
        string mode;
        uint256 duration;
        uint256 theme;
    }

struct ItemSettings {
        string itemId;
        string settings;
    }

struct WorkItem {
        uint tokenId;
        address contractAddress;
    }
struct Theme {
        uint hue;
        uint sat;
        uint contrast;
        string name;
        string[5] colors;
    }


interface IStyles {
    function getStyle(uint styleId) external pure returns (string memory style );
}