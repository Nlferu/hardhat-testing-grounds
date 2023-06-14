const { expect, assert } = require("chai")
const { ethers } = require("hardhat")

describe("Proceed", function () {
    it("Should handle failed transfer", async function () {
        // Deploy contracts
        const Proceed = await ethers.getContractFactory("Proceed")
        const proceed = await Proceed.deploy(100) // Set minFund to 100 (example value)
        await proceed.deployed()

        const ProFake = await ethers.getContractFactory("ProFake")
        const proFake = await ProFake.deploy()
        await proFake.deployed()

        // Get the accounts from Hardhat
        const [recipient] = await ethers.getSigners()

        // Fund the contract from the recipient account
        const fundingAmount = ethers.utils.parseEther("1") // Example funding amount
        await proceed.connect(recipient).fundContract({ value: fundingAmount })

        const proceedBalance = await ethers.provider.getBalance(proceed.address)
        const fakeBalance = await ethers.provider.getBalance(proFake.address)

        assert.equal(proceedBalance.toString(), ethers.utils.parseEther("1").toString())
        assert.equal(fakeBalance.toString(), "0")

        // Withdrawing into ProFake contract -> this transfer will fail (look into ProFake contract)
        await expect(proceed.connect(recipient).withdrawPending(proFake.address)).to.be.revertedWith(`TransferFailed("${recipient.address}", ${fundingAmount})`)

        // Withdrawing into proper address -> this transfer will pass successfully
        await expect(proceed.connect(recipient).withdrawPending(recipient.address))
            .to.emit(proceed, "PendingBidsWithdrawal")
            .withArgs(fundingAmount, recipient.address, true)
    })
})
