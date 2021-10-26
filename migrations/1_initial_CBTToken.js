const CBTToken = artifacts.require("CBTToken");


module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(CBTToken);
  const cbt = await CBTToken.deployed();
};
