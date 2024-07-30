const {ethers, artifacts} = require("hardhat")
const { expect, assert } = require("chai");
// const idArray = [0, 10, 40, 90, 130, 170, 210, 250, 280, 310, 330, 569, 360, 361]
const idArray = [0, 10]
const doThemes = true;
const doOrigins = true;
const allMode = false;
const doStyle = true;  
const doGallery = false;  

const whitelistAddress = '0x5F16f8Dc7a246315fD94793FDE8470eA85A40fD4'

describe("PrmntOrigins", function () {
  let signerOwner
  let PrmntOriginsFactory;
  let PrmntOrigins;
  
  let PrmntStylesFactory;
  let PrmntStyles;
  
  let PrmntGalleryFactory;
  let PrmntGallery;
  
  beforeEach(async function () {
    console.log('* * * * ');
    console.log('Getting signer...');
    const [owner, otherAccount] = await ethers.getSigners();
    signerOwner = owner.address;
    console.log('signerOwner is', signerOwner)
    if (!signerOwner) {
      console.error('NO SIGNER/OWNER');
      return
    }
  
    PrmntOriginsFactory = await ethers.getContractFactory("PrmntOrigins")
    PrmntOrigins = await PrmntOriginsFactory.deploy(signerOwner,"PrmntOrigins", "PRMNT", signerOwner, 500, whitelistAddress);
    console.log('PrmntOrigins.target is', PrmntOrigins.target);

    PrmntStylesFactory = await ethers.getContractFactory("PrmntStyles")
    PrmntStyles = await PrmntStylesFactory.deploy();
    console.log('PrmntStyles.addrtargetess is', PrmntStyles.target);
    console.log(' * * * * * * *')
    
    // PrmntGalleryFactory = await ethers.getContractFactory("PrmntGallery")
    // PrmntGallery = await PrmntGalleryFactory.deploy(signerOwner,"PrmntGallery", "PRMNT", signerOwner, 500);
    // console.log('PrmntGallery.address is', PrmntGallery.address);
    console.log(' * * * * * * *')
  });
  
  if(doOrigins){
  it("Should set an artwork", async function () {
    const expectedId = 0
    const expectedHue = getRandomInt(0, 359)
    // const eDuration = 20
    // const eIntensity = 8
    // const eProgress = 50
    const attributes = {
        duration: getRandomInt(1, 40),
        intensity: getRandomInt(1, 20),
        progress: getRandomInt(20, 100),
        depth: getRandomInt(1, 100),
        scale: getRandomInt(30, 200),
      }
      const transactionResponseClaim = await PrmntOrigins.claim(
        expectedHue,
        attributes.duration, 
        attributes.intensity, 
        attributes.progress,
        attributes.depth,
        // [], // default works
      );
      await transactionResponseClaim.wait(1);
    const transactionResponse = await PrmntOrigins.setAttributes(
      expectedId, 
      attributes.duration, 
      attributes.intensity, 
      attributes.progress,
      attributes.depth,
      attributes.scale,
    );
    transactionResponse.wait(1)
    console.log('set attributes transactionResponse', transactionResponse);
    const currentValue = await PrmntOrigins.getAttributes(expectedId); 
    console.log('currentValue', currentValue)
    const currentURI = await PrmntOrigins.tokenURI(expectedId);
    console.log('currentURI', currentURI)
    const currentImage = await PrmntOrigins.getImage(expectedId);
    console.log('currentImage', currentImage)
    
    
    
    expect(currentValue).to.be.a('array');
    // assert.equal(currentValue.toString(), expectedValue)
  })
  }
  // it("Should get an intensity", async function () {
  //   const expectedValue = "12"
  //   const currentValue = await PrmntOrigins.getIntensity(0);
  //   console.log("INTENSITY: ", currentValue)
  //   expect(currentValue.toNumber()).to.be.a('number');
  //   // assert.equal(currentValue.toString(), expectedValue)
  // })
  // it("Should get a duration", async function () {
  //   const currentValue = await PrmntOrigins.getDuration(0);
  //   console.log("DURATION: ", currentValue)
  //   expect(currentValue.toNumber()).to.be.a('number');
  // })
  // it("Should get a progress", async function () {
  //   const currentValue = await PrmntOrigins.getProgress(1);
  //   console.log("PROGRESS: ", currentValue)
  //   expect(currentValue.toNumber()).to.be.a('number');
  // })
  // it("Should get a color", async function () {
  //   const tokenId = 0;
  //   const colorIndex = 1;
  //   const currentValue = await PrmntOrigins.getThemeColor(tokenId, colorIndex);
  //   console.log("COLOR: ", currentValue)
  //   expect(currentValue).to.be.a('string');
  // })
  // it("Should get Artwork 2", async function () {
  //   const  id = 2;
  //   const currentValue = await PrmntOrigins.getArtwork(id);
  //   const currentProgress = await PrmntOrigins.getProgress(id);
  //   const currentIntensity = await PrmntOrigins.getIntensity(id);
  //   console.log("Artwork 2: ", currentValue)
  //   console.log("Artwork 2 Progress: ", currentProgress)
  //   console.log("Artwork 2 Intensity: ", currentIntensity)
  //   expect(currentValue).to.be.a('string');
  // })
  // it("Should get Artwork 90", async function () {
  //   const  id = 90;
  //   const currentValue = await PrmntOrigins.getArtwork(id);
  //   const currentProgress = await PrmntOrigins.getProgress(id);
  //   const currentIntensity = await PrmntOrigins.getIntensity(id);
  //   console.log("Artwork 90: ", currentValue)
  //   console.log("Artwork 90 Progress: ", currentProgress)
  //   console.log("Artwork 90 Intensity: ", currentIntensity)
  //   expect(currentValue).to.be.a('string');
  // })
  // it("Should get Artwork 180", async function () {
  //   const  id = 180;
  //   const currentValue = await PrmntOrigins.getArtwork(id);
  //   const currentProgress = await PrmntOrigins.getProgress(id);
  //   const currentIntensity = await PrmntOrigins.getIntensity(id);
  //   console.log("Artwork 180: ", currentValue)
  //   console.log("Artwork 180 Progress: ", currentProgress)
  //   console.log("Artwork 180 Intensity: ", currentIntensity)
  //   expect(currentValue).to.be.a('string');
  // })
  // it("Should get a URI 179", async function () {
  //   const currentValue = await PrmntOrigins.tokenURI(179);
  //   console.log("URI 179: ", currentValue)
  //   expect(currentValue).to.be.a('string');
  // })
  // it("Should get a URI 270", async function () {
  //   const currentValue = await PrmntOrigins.tokenURI(270);
  //   console.log("URI 270: ", currentValue)
  //   expect(currentValue).to.be.a('string');
  // })
  if (doThemes) {
    it("Should Resolve theme functions", async function () {
    const testTheme2b = await PrmntOrigins.createThemeValues(220, 80, 80);
    console.log('testTheme2b', testTheme2b)
    // const currentItemTheme = await PrmntOrigins.getTheme(expectedId);
    });
  }
  if (doOrigins && !allMode) {
    it("Should Claim a Token", async function () {
      const expectedId = 0;
      // const expectedHue = 20; //getRandomInt(0, 359);
      const expectedHue = getRandomInt(0, 359);
      const expectedCount = 1;
      const attributes = {
        duration: getRandomInt(10, 40),
        intensity: getRandomInt(1, 100),
        progress: getRandomInt(20, 100),
        depth: getRandomInt(10, 80),
        scale: getRandomInt(10, 200),
        // depth: 50,
      }
      const transactionResponse = await PrmntOrigins.claim(
        expectedHue,
        attributes.duration, 
        attributes.intensity, 
        attributes.progress,
        attributes.depth,
        // [] // ddefault works
        // expectedCount
      );
      await transactionResponse.wait(1);
      // console.log('transactionResponse', transactionResponse)
      
      const currentIsAnimated = await PrmntOrigins.getIsAnimated(expectedId);
      console.log(`currentIsAnimated (#${expectedId})`, currentIsAnimated)
      console.log('--------')
      
      const currentArtwork = await PrmntOrigins.getAttributes(expectedId);
      console.log(`currentArtwork (#${expectedId})`, currentArtwork)
      const currentURI = await PrmntOrigins.tokenURI(expectedId);
      console.log('currentURI')
      console.log(currentURI)
      const currentImage = await PrmntOrigins.getImage(expectedId);
      console.log('https://localhost:3000/')
      console.log('currentImage')
      console.log(currentImage)
      const currentBase64 = await PrmntOrigins.getBase64Image(expectedId);
      console.log('------')
      console.log(currentBase64)
      console.log('------')
    
      const ownerOf = await PrmntOrigins.ownerOf(expectedId);
      console.log('ownerOf', ownerOf)
      await PrmntOrigins.ownerOf(expectedId);
      
      // const transactionResponse1 = await PrmntOrigins.addItem(expectedId, 'stirngslskdfjsldfs');
      // await transactionResponse1.wait(1)
      // const transactionResponse2 = await PrmntOrigins.addItem(expectedId, 'sdfsdf');
      // await transactionResponse2.wait(1)
      // const transactionResponse3 = await PrmntOrigins.removeItem(expectedId, 1);
      // await transactionResponse3.wait(1)
      
      const addFragmentContract0 = await PrmntOrigins.addFragmentContract(PrmntStyles.target);
      await addFragmentContract0.wait(1)
      const fragmentContracts = await PrmntOrigins.getFragmentContracts();
      console.log('fragmentContracts', fragmentContracts)

      // const currentItems = await PrmntOrigins.getGalleryItems(expectedId);
      // console.log(`currentItems (#${expectedId})`, currentItems)

      // const transactionResponse4 = await PrmntOrigins.setGalleryItems(expectedId, ['stirngslskdfjsldfs', 'sdf','sdf']);
      // await transactionResponse4.wait(1)
      // const currentItems3 = await PrmntOrigins.getGalleryItems(expectedId);
      // console.log(`currentItems3 (#${expectedId})`, currentItems3)
      // const transactionResponse5 = await PrmntOrigins.setItemSettings(expectedId, '8001:0x123:2', "{'duration': 12, 'depth': 34}");
      // await transactionResponse5.wait(1)
      
      // const galleryItemSettings = await PrmntOrigins.getItemSettings(expectedId, '8001:0x123:2');
      // console.log('galleryItemSettings', galleryItemSettings)

      const transactionResponseGallery = await PrmntOrigins.setGallerySettings(expectedId, {mode: 'page', duration: 10, theme: 1, });
      await transactionResponseGallery.wait(1)

      const currentItemGallerySettings = await PrmntOrigins.getGallerySettings(expectedId);
      console.log('currentItemGallerySettings', currentItemGallerySettings)
      
      const currentItemTheme = await PrmntOrigins.getTheme(expectedId);
      console.log('currentItemTheme', currentItemTheme)
      const currentItemThemeName = await PrmntOrigins.getThemeName(expectedId);
      console.log('currentItemThemeName', currentItemThemeName)
      const currentItemThemeColors = await PrmntOrigins.getThemeColors(expectedId);
      console.log('currentItemThemeColors', currentItemThemeColors)
      
      const themeColor0 = await PrmntOrigins.getColor(expectedId, 0);
      const themeColor4 = await PrmntOrigins.getColor(expectedId, 4);
      console.log('themeColor0', themeColor0)
      console.log('themeColor4', themeColor4)
      await PrmntOrigins.setThemeAttributes(expectedId, 10, 40);
      const updatedItemThemeColors = await PrmntOrigins.getThemeColors(expectedId);
      console.log('updatedItemThemeColors', updatedItemThemeColors)
      

      expect(currentImage).to.be.a('string');
    });
  }
  if(doStyle){
  it("Should TEST styles", async function () {
    console.log('starting styles....')
    const expectedStyleId = 0;
    const transactionResponse = await PrmntStyles.mintStyle(PrmntOrigins.target, '.test{blkejre:sdfsdf;}');
    await transactionResponse.wait(1)
    const transactionResponse2 = await PrmntStyles.mintStyle(PrmntOrigins.target, '.aother .style{background:red;}');
    await transactionResponse2.wait(1)
    const currentStyle = await PrmntStyles.getStyle(expectedStyleId);
    console.log('currentStyle', currentStyle)
    const currentStyle2 = await PrmntStyles.getStyle(expectedStyleId + 1);
    console.log('currentStyle2', currentStyle2)
    const currentContractStyle = await PrmntStyles.getContractStyle(PrmntOrigins.target);
    console.log('currentContractStyle', currentContractStyle)
    const currentContractStyleByIndex = await PrmntStyles.getContractStyleByIndex(PrmntOrigins.target, 1);
    console.log('currentContractStyleByIndex', currentContractStyleByIndex)
    const currentContractStyles = await PrmntStyles.getContractStyles(PrmntOrigins.target);
    console.log('currentContractStyles', currentContractStyles)
    // const galleryItemsFromContract = await PrmntOrigins.getGalleryItemsFromContract(PrmntOrigins.target, 80001, 23, 20);
    // console.log('galleryItemsFromContract', galleryItemsFromContract)
  })
  }
  
  if(doGallery){
  it("Should TEST gallery", async function () {

    const expectedId = 0;

      const transactionResponse = await PrmntGallery.claim(
        [] // ddefault works
      );
      await transactionResponse.wait(1);
      // console.log('transactionResponse', transactionResponse)
      
      
      console.log('--------')
      
      const currentArtwork = await PrmntGallery.getAttributes(expectedId);
      console.log(`currentArtwork (#${expectedId})`, currentArtwork)
      const currentURI = await PrmntGallery.tokenURI(expectedId);
      console.log('currentURI')
      console.log(currentURI)
      const currentImage = await PrmntGallery.getImage(expectedId, 0);
      console.log('currentImage')
      console.log(currentImage)
      const currentImage2 = await PrmntGallery.getImage(expectedId + 1, 17);
      console.log('currentImage2')
      console.log(currentImage2)
      const currentImage3 = await PrmntGallery.getImage(expectedId + 2, 37);
      console.log('currentImage3')
      console.log(currentImage3)
      const currentBase64 = await PrmntGallery.getBase64Image(expectedId);
      console.log('------')
      console.log(currentBase64)
      console.log('------')

      /**
       * get and get ids
       */
      const transactionResponse6 = await PrmntGallery.setGalleryIds(expectedId, [0,1,2,3,4]);
      await transactionResponse6.wait(1)

      const currentItemGalleryIds = await PrmntGallery.getGalleryIds(expectedId);
      console.log('currentItemGalleryIds', currentItemGalleryIds)
      
  })
  }

  // it("Should get next ID to mint", async function () {
  //   const expectedValue = 0;
  //   const currentValue = await PrmntOrigins.nextTokenIdToMint();
  //   assert.equal(currentValue.toString(), expectedValue)
  // })
  if (doOrigins && allMode && idArray) {
    console.log('ALL MODE')
    let index = 0;
    it('Should Claim a Token of many', async (done) => {
      console.log('indexid', index)
      const expectedId = index;
      // const transactionResponsecreat = await PrmntOrigins.createGallery(expectedId);
      const transactionResponse = await PrmntOrigins.createGallery(expectedId);
      await transactionResponse.wait(1)
      
        expect(transactionResponse).to.equal('promise resolved'); 
        // console.log('transactionResponse', response)
        const currentArtwork = await PrmntOrigins.getAttributes(index);
        console.log(`currentArtwork (#${index})`, currentArtwork)
        const currentToken = await PrmntOrigins.tokenURI(index)
        console.log('currentToken', currentToken)
        const currentProgress = await PrmntOrigins.getProgress(id)
        console.log('currentProgress', currentProgress)
        expect(currentToken).to.be.a('string');
        done();
          
    });
   
    idArray.forEach(function (id, index) {
        console.log('ALL MODE index: ', index)
        
        
      });
   // })
  }
})

const getRandomInt = (min, max) => {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
};
