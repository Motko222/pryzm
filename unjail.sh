#!/bin/bash
echo $PWD | pryzmd tx slashing unjail --from $KEY --chain-id indigo-1 --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y 
