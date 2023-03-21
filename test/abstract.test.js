const { expect } = require("chai")
const { BigNumber } = require("ethers")
const { network, ethers } = require("hardhat")
const { parseEther } = require("ethers/lib/utils")
const { developmentChains } = require("../helper-hardhat-config")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("Attack", () => {
          it("Should empty the balance of the AbstractImpulseNotProtected", async function () {
              // Deploy the abstract contract
              const abstractNotProtectedFactory = await ethers.getContractFactory("AbstractNotProtected")
              const abstractNotProtected = await abstractNotProtectedFactory.deploy()
              await abstractNotProtected.deployed()

              // Deploy the malicious contract
              const maliciousContractForNotProtFactory = await ethers.getContractFactory("MaliciousContractForNotProt")
              const maliciousContractForNotProt = await maliciousContractForNotProtFactory.deploy(abstractNotProtected.address)
              await maliciousContractForNotProt.deployed()

              const victimAdd = await maliciousContractForNotProt.getVictim()
              console.log(`Victim Address: ${victimAdd} NFT Add: ${abstractNotProtected.address}`)

              // Get two addresses, treat one as innocent user and one as attacker
              const [_, innocentAddress, attackerAddress] = await ethers.getSigners()
              console.log(`Innocent: ${innocentAddress.address} Attacker: ${attackerAddress.address}`)

              // Innocent User bid for 10 ETH NFT
              let tx = await abstractNotProtected.connect(innocentAddress).addBalance({ value: parseEther("10") })
              await tx.wait()

              // Check that at this point the abstractImpulse's balance is 10 ETH
              let balanceETH = await ethers.provider.getBalance(abstractNotProtected.address)
              console.log(`Abstract Balance: ${balanceETH}`)
              expect(balanceETH).to.equal(parseEther("10"))

              // Attacker calls the `attack` function on MaliciousContract
              // and sends 1 ETH
              tx = await maliciousContractForNotProt.connect(attackerAddress).attack({ value: parseEther("1") })
              await tx.wait()

              // Balance of abstractNotProtected address is now 0
              balanceETH = await ethers.provider.getBalance(abstractNotProtected.address)
              console.log(`Abstract Balance After Attack: ${balanceETH}`)
              expect(balanceETH).to.equal(BigNumber.from("0"))

              // Balance of maliciousContract is now 11 ETH
              balanceETH = await ethers.provider.getBalance(maliciousContractForNotProt.address)
              console.log(`Malicious Balance After Attack: ${balanceETH}`)
              expect(balanceETH).to.equal(parseEther("11"))
          })
          it("Should NOT!!! empty the balance of the AbstractImpulseProtected", async function () {
              // Deploy the abstract contract
              const abstractProtectedFactory = await ethers.getContractFactory("AbstractProtected")
              const abstractProtected = await abstractProtectedFactory.deploy()
              await abstractProtected.deployed()

              // Deploy the malicious contract
              const maliciousContractForProtFactory = await ethers.getContractFactory("MaliciousContractForProt")
              const maliciousContractForProt = await maliciousContractForProtFactory.deploy(abstractProtected.address)
              await maliciousContractForProt.deployed()

              const victimAdd = await maliciousContractForProt.getVictim()
              console.log(`Victim Address: ${victimAdd} NFT Add: ${abstractProtected.address}`)

              // Get two addresses, treat one as innocent user and one as attacker
              const [_, innocentAddress, attackerAddress] = await ethers.getSigners()
              console.log(`Innocent: ${innocentAddress.address} Attacker: ${attackerAddress.address}`)

              // Innocent User bid for 10 ETH NFT
              let tx = await abstractProtected.connect(innocentAddress).addBalance({ value: parseEther("10") })
              await tx.wait()

              // Check that at this point the abstractImpulse's balance is 10 ETH
              let balanceETH = await ethers.provider.getBalance(abstractProtected.address)
              console.log(`Abstract Balance: ${balanceETH}`)
              expect(balanceETH).to.equal(parseEther("10"))

              // Attacker calls the `attack` function on MaliciousContract
              // and sends 1 ETH
              await expect(maliciousContractForProt.connect(attackerAddress).attack({ value: parseEther("1") })).to.be.revertedWith("Failed to send ether")

              // Balance of abstractProtected address is still 10
              balanceETH = await ethers.provider.getBalance(abstractProtected.address)
              console.log(`Abstract Balance After Attack: ${balanceETH}`)
              expect(balanceETH).to.equal(parseEther("10"))

              // Balance of maliciousContract is still 0 ETH
              balanceETH = await ethers.provider.getBalance(maliciousContractForProt.address)
              console.log(`Malicious Balance After Attack: ${balanceETH}`)
              expect(balanceETH).to.equal(BigNumber.from("0"))
          })
      })
