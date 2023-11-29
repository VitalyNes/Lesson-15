const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Horse and Farmer Tests", function () {
  let Horse, horse, Farmer, farmer;

  beforeEach(async function () {
    Horse = await ethers.getContractFactory("Horse"); 
    horse = await Horse.deploy("Tamerlan");
    console.log("Horse deployed to:", horse.address);

    Farmer = await ethers.getContractFactory("Farmer"); 
    farmer = await Farmer.deploy();
    console.log("Farmer deployed to:", farmer.address);

    await farmer.addAnimal(horse.address);
  });

  it("Horse has the correct name", async function () {
    const name = await horse.getName();
    expect(name).to.equal("Tamerlan");
  });

  it("Horse can sleep", async function () {
    const canSleep = await horse.sleep();
    expect(canSleep).to.equal("Z-z-z...");
  });

  it("Horse can eat 'plant'", async function () {
    const result = await horse.eat("plant");
    
    expect(result).to.emit(horse, "Ate").withArgs("plant");
  });

  it("Horse cannot eat 'meat', 'not-food', 'plastic'", async function () {
    try {
      await horse.eat("meat");
      throw new Error("Expected transaction to revert");
    } catch (error) {
      
      expect(error.message).to.include("Can only eat plant food");
    }
  });

  it("Farmer can call Horse, Horse responds correctly", async function () {
    const response = await farmer.callByAddress(horse.address);
    expect(response).to.equal("Igogo");
  });

  it("Farmer can feed Horse with plant", async function () {
    const result = await farmer.feedByAddress(horse.address, "plant");
    expect(result).to.emit(horse, "Ate").withArgs("plant");
  });

  it("Farmer cannot feed Horse with anything else", async function () {
    try {
      await farmer.feedByAddress(horse.address, "meat");
      throw new Error("Expected transaction to revert");
    } catch (error) {
      expect(error.message).to.include("Can only eat plant food");
    }
  });
});
