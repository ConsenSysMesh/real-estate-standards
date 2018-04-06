const MetadataRegistry = artifacts.require("./MetadataRegistry");

const key = "123";
const multiaddr = "abc"; 

contract('MetadataRegistry', async (accounts) => {
	it("should add a new link to the registry", async () => {
		const instance = await MetadataRegistry.deployed();
		await instance.setLink(accounts[1], key, multiaddr, {from:accounts[0]});
		let numLinks = await instance.getNumLinks(); 	
		assert.equal(numLinks, 1);
	});

	it("should remove a link from the registry", async () => {
		const instance = await MetadataRegistry.deployed();
		await instance.removeLink(accounts[1], key, {from: accounts[0]});
		let numLinks = await instance.getNumLinks();
		assert.equal(numLinks, 0);
	});
});


