var SpatialUnitRegistry = artifacts.require("./SpatialUnitRegistry");
var MetadataRegistry = artifacts.require("./MetadataRegistry");
var RightsRegistry = artifacts.require("./RightsRegistry");

module.exports = function(deployer) {
	deployer.deploy(SpatialUnitRegistry);
	deployer.deploy(MetadataRegistry);
	deployer.deploy(RightsRegistry);
};
