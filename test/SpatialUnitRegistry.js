const SpatialUnitRegistry = artifacts.require("./SpatialUnitRegistry");
const SpatialUnit = artifacts.require("./SpatialUnit");

const alias = "123";
const geoHash = "abc";

contract("SpatialUnitRegistry", async (accounts) => {
	it("should create a new spatial unit and add it to the registry", async () => {
		const instance = await SpatialUnitRegistry.deployed();
		await instance.addSpatialUnit(alias, geoHash, {from:accounts[0]});
		let numSpatialUnits = await instance.numSpUnits();
	});
	it("creation of contract via contract factory"), async (accounts) => {
		const instance = await SpatialUnitRegistry.deployed();
		let result = await instance.addSpatialUnit(alias, geoHash, {from: accounts[0]});
		let log = result.logs[0];
		let spatialUnitAddr = log.args._newContract;

		// get instance pointing to address obtained from event
		const spUnit = await SpatialUnitRegistry.at(spatialUnitAddr);

		let spUnitBal = await spUnit.getBalance();

		assert.equal(spUnitBal, 0);
	}
	
	it("contract deployed by factory should be owned by msg.sender invoking addSpatialUnit function", async () => {
		
		assert.equal(owner, owner);
	})
});

