var MultiEscrow = artifacts.require("./MultiEscrow");
//var testrow = artifacts.require("./testrow");

module.exports = function(deployer) {
    deployer.deploy(MultiEscrow);
    //deployer.deploy(testrow);
}