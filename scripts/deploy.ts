import { ethers } from "ethers";
import * as fs from "fs";
import * as dotenv from "dotenv";
import ABI from '../artifacts/contracts/Gifts.sol/Gift1155.json'

dotenv.config();

// Configuración
const RPC_URL = process.env.SEPOLIA_RPC_URL!;
const PRIVATE_KEY = process.env.SEPOLIA_PRIVATE_KEY!;
console.log("RPC:", process.env.SEPOLIA_RPC_URL);
console.log("PK:", process.env.SEPOLIA_PRIVATE_KEY);



async function main() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const factory = new ethers.ContractFactory(ABI.abi, ABI.bytecode, wallet);
  const contract = await factory.deploy();

  console.log("Deploying...");
  await contract.waitForDeployment();
    const address = await contract.getAddress()
  console.log("Gift1155 deployed to:", address);
}

main().catch((err) => {
  console.error("Error deploying:", err);
});