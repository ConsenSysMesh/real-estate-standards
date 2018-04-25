#!/bin/bash
truffle migrate --network rpc --reset > /dev/null &
sleep 1
set -x 
truffle migrate --network rpc --reset
