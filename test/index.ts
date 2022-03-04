import { expect } from "chai";
import { ethers } from "hardhat";

describe("TimeStamp", function () {
  it("Check Insertion", async function () {
    const TimeStamp = await ethers.getContractFactory("TimeStampHash");
    const timestamp = await TimeStamp.deploy();
    await timestamp.deployed();

    const insertTimeStamp = await timestamp.insertTimeStamp(
      "0x46696c6531446174610000000000000000000000000000000000000000000000",
      "0x46696c6531000000000000000000000000000000000000000000000000000000"
    );

    // wait until the transaction is mined
    await insertTimeStamp.wait();
    expect(
      await timestamp.getTimeStamp(
        "0x46696c6531000000000000000000000000000000000000000000000000000000"
      )
    ).to.equal(
      "0x46696c6531446174610000000000000000000000000000000000000000000000"
    );
  });
});
