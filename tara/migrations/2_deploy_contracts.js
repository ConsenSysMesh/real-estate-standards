var MetadataRegistry = artifacts.require("./MetadataRegistry");
var SpatialUnitRegistry = artifacts.require("./SpatialUnitRegistry");
var RightsRegistry = artifacts.require("./RightsRegistry");

module.exports = function(deployer) {
	deployer.deploy(MetadataRegistry);
	deployer.deploy(SpatialUnitRegistry);
	deployer.deploy(RightsRegistry);
}; 
