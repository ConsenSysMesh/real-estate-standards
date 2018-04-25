var Web3 = require("web3");

module.exports = {
	networks: {		
		development: {
			host: "127.0.0.1",
			port: 8545,
			network_id: "*"
		},
		rpc: {
			provider: () => {
				return new Web3.providers.HttpProvider("https://j3m3ztc1-txv9f7bz-rpc.stage.photic.io", 0, "e8no7oto", "zefTPxdmeOIFiZ1hlDXm4Xt44SQIg8iJlq15sz7AUAY");
			},
			network_id: "*",
			gasPrice: 0,
			gas: 4500000
		}
	}
};
