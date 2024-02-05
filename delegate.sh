#!/bin/bash
source ~/scripts/pryzm/config/env

if [ -z $1 ]
then
 read -p "From key (default $KEY) ? " key
 if [ -z $key ]; then key=$KEY; fi
else
 key=$1
fi

if [ -z $2 ]
then
 read -p "To valoper (default $VALOPER) ? " valoper
 if [ -z $valoper ]; then valoper=$VALOPER; fi
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
