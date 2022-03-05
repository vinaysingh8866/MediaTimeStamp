import { expect } from "chai";
import { ethers } from "hardhat";
import { TimeStampHash } from "../typechain";

describe("TimeStamp", function () {
  let timestamp: TimeStampHash;
  beforeEach(async function () {
    const TimeStamp = await ethers.getContractFactory("TimeStampHash");
    timestamp = await TimeStamp.deploy();
    await timestamp.deployed();
  });

  it("Check Insertion", async function () {
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

  it("Check Multiple Insertion", async function () {
    const insertTimeStamp = await timestamp.insertMultiple(
      [
        "0x46696c6531406174910000000000000000000000000000000000000000000000",
        "0x46696c6531446174610000000000000000000000000000000000000000000000",
      ],
      [
        "0x46696c6511000000000000000000000000000000000000000000000000000000",
        "0x46696c6530000000000000000000000000000000000000000000000000000000",
      ]
    );

    // wait until the transaction is mined
    await insertTimeStamp.wait();
    expect(
      await timestamp.getTimeStamp(
        "0x46696c6511000000000000000000000000000000000000000000000000000000"
      )
    ).to.equal(
      "0x46696c6531406174910000000000000000000000000000000000000000000000"
    );

    expect(
      await timestamp.getTimeStamp(
        "0x46696c6530000000000000000000000000000000000000000000000000000000"
      )
    ).to.equal(
      "0x46696c6531446174610000000000000000000000000000000000000000000000"
    );
  });

  it("Check Image Meta Insertion", async function () {
    const insertTimeStamp = await timestamp.insertImageMeta(
      "90.0000°N,135.0000°W",
      "0x46696c6531000000000000000000000000000000000000000000000000000000"
    );

    // wait until the transaction is mined
    await insertTimeStamp.wait();

    const blockNumBefore = await ethers.provider.getBlockNumber();
    const blockBefore = await ethers.provider.getBlock(blockNumBefore);
    const timestampBefore = blockBefore.timestamp;
    const val = await timestamp.getImageMeta(
      "0x46696c6531000000000000000000000000000000000000000000000000000000"
    );
    expect(val[0].toNumber()).to.equal(timestampBefore);
    expect(val[1]).to.equal("90.0000°N,135.0000°W");
    console.log(val[1]);
  });
});
