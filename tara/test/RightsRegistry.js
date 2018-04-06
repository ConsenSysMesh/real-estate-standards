const RightsRegistry = artifacts.require("./RightsRegistry");

//const targetEntity = accounts[0];
//const holderEntity = accounts[1];
//const rightsType = "publicproperty";

contract("RightsRegistry", async (accounts) => {
	it("should create a new right", async () => {
		const instance = await RightsRegistry.deployed();
		//await instance.addRight(targetEntity, holderEntity, rightsType);
		await instance.addRight(accounts[0], accounts[1], "publicproperty");
		let numRights = instance.getNumRights();
		assert.equal(numRights, 1);
	});
});
