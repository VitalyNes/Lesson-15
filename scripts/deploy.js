async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);

  const AllContracts = await ethers.getContractFactory("AllContracts");
  const yourContract = await AllContracts.deploy();

  console.log(`AllContracts address: ${yourContract.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
