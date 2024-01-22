#!/bin/bash
source ~/scripts/pryzm/config/env

if [ -z $1 ]
then
 read -p "From key ? " key
else
 key=$1
fi

if [ -z $2 ]
then
 read -p "To valoper (blank to delegate to this valoper) ? " valoper
 if [ -z $valoper ]; then valoper=$(echo $PWD | pryzmd keys show $KEY --bech val | head -1 | awk '{print $3}'); fi
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
