#!/bin/bash

FOLDER=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$FOLDER/config/env

valoper=$(echo $PWD | pryzmd keys show $KEY -a --bech val)

echo $PWD | pryzmd tx distribution withdraw-rewards $valoper \
--from $KEY --commission \
--chain-id indigo-1 --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
