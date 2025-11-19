import { ethers } from "ethers";
import * as dotenv from "dotenv";
import ABI from "../artifacts/contracts/Gifts.sol/Gift1155.json";

dotenv.config();

// Configuración
const RPC_URL = process.env.SEPOLIA_RPC_URL!;
const PRIVATE_KEY = process.env.SEPOLIA_PRIVATE_KEY!;
const CONTRACT_ADDRESS = "0xA1e42076a5bf3885143eeD89c369c12CA84468A2";

async function main() {
  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
  const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI.abi, wallet);

  // Parámetros del regalo
  const recipient = "0x90813c2c61ee01857c2fdfd003f5272b540a7aa7"; 
  const amount = 1;
  const name = "Regalo de Blas";
  const data = "0x";

  const tx = await contract.mintGift(recipient, amount, name, data);
  console.log("Minting...");
  await tx.wait();

  console.log(`✅ Minted "${name}" to ${recipient}`);
}

main().catch((err) => {
  console.error("Error minting:", err);
});