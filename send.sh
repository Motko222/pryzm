#!/bin/bash

source ~/scripts/pryzm/config/env

[ -z $1 ] && read -p "From key or wallet ? " from || from=$1

wallet=$(echo $PWD | $BINARY keys show $from -a)
balance1=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount )
balance2=$($BINARY query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim")' | jq -r .amount )
echo Balance $((balance1))upryzm $((balance2))factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim

[ -z $2 ] && read -p "To wallet ? " to || to=$2
[ -z $3 ] && read -p "Amount incl. denom ? " amount || amount=$3

echo $PWD | pryzmd tx bank send $from $to $amount \
   --gas-prices $GAS_PRICE --gas-adjustment $GAS_ADJ --gas auto -y | tail -1
