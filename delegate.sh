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
 read -p "To valoper ? " valoper
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

babylond tx staking delegate $valoper $amount --from $key \
 --chain-id indigo-1 --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
