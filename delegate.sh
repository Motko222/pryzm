#!/bin/bash
source ~/scripts/pryzm/config/env

if [ -z $1 ]
then
 read -p "From key (default $KEY) ? " key
 if [ -z $key ]; then key=$KEY; fi
else
 key=$1
fi

wallet=$(echo $PWD | pryzmd keys show $key -a)
balance1=$(pryzmd query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount | awk '{print $1/1000000}')
echo "Balance: $balance1 pryzm"

if [ -z $2 ]
then
 def_valoper=$(echo $PWD | pryzmd keys show $key -a --bech val)
 read -p "To valoper (default $def_valoper) ? " valoper
 if [ -z $valoper ]; then valoper=$def_valoper; fi
else
 valoper=$2
fi

if [ -z $3 ]
then
 read -p "Amount (pryzm)  ? " amount
else
 amount=$3
fi

amount=$(( $amount * 1000000 ))upryzm

echo $PWD | pryzmd tx staking delegate $valoper $amount --from $key \
 --chain-id indigo-1 --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
