const hre = require("hardhat");

async function main() {
    // Get the ContractFactory and Signers here
    const BondingCurveToken = await hre.ethers.getContractFactory("BondingCurveToken");

    // Deploy the contract with the desired parameters
    const initialReservePrice = ethers.utils.parseEther("0.01");
    const token = await BondingCurveToken.deploy("HarmonyBondingCurveToken", "HBCURVE", initialReservePrice);

    // Wait for the contract to be deployed
    await token.deployed();

    console.log("BondingCurveToken deployed to:", token.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
