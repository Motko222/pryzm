#!/bin/bash

FOLDER=$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')
source ~/scripts/$(echo $(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) | awk -F/ '{print $NF}')/config/env

if [ -z $1 ]
then
 read -p "From key (default $KEY) ? " key
 if [ -z $key ]; then key=$KEY; fi
else
 key=$1
fi

wallet=$(echo $PWD | $BINARY keys show $key -a)
balance=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount | awk '{print $1/1000000}')
echo "Balance: $balance pryzm"

if [ -z $2 ]
then
 def_valoper=$(echo $PWD | $BINARY keys show $key -a --bech val)
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

echo $PWD | $BINARY tx staking delegate $valoper $amount --from $key \
 --chain-id $NETWORK --gas-prices $GAS_PRICE --gas-adjustment $GAS_ADJ --gas auto -y
