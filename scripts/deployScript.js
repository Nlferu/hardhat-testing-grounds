async function main() {
    const contract = await ethers.getContractFactory("DeployContract")
    const x = 42

    const contractDeployed = await contract.deploy(x)
    await contractDeployed.deployed()

    console.log("Contract deployed to:", contractDeployed.address)
    console.log("Owner:", await contractDeployed.owner())
    console.log("x:", (await contractDeployed.x()).toString())
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
