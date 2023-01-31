const { ethers } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    let emitNumberOne, emitNumberTwo, emitAddress, emitBool
    const ourNum = 70

    log(`Deploying TestCon...`)
    arguments = []
    await deploy("TestCon", { from: deployer, args: arguments, log: true, waitConfirmations: 1 })
    const testCon = await ethers.getContract("TestCon", deployer)

    // Using Contract Functions:
    const responseTx = await testCon.counterFun(ourNum)
    const receiptTx = await responseTx.wait()

    // Reading Emit Values:
    emitNumberOne = receiptTx.events[0].args.storedNumOne
    emitNumberTwo = receiptTx.events[1].args.passedNumTwo
    emitAddress = receiptTx.events[0].args.addressOne
    emitBool = receiptTx.events[1].args.initialize
    log(`First Event Data -> numberOne: ${emitNumberOne} address: ${emitAddress}`)
    log(`Second Event Data -> numberTwo: ${emitNumberTwo} bool: ${emitBool}`)
}

module.exports.tags = ["all", "deploy"]
