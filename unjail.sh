#!/bin/bash
source ~/scripts/pryzm/config/env
echo $PWD | pryzmd tx slashing unjail --from $KEY --chain-id indigo-1 --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y 
