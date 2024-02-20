#!/bin/bash

source ~/scripts/pryzm/config/env

[ -z $1 ] && from=$1 || read -p "From key or wallet ? " from
[ -z $2 ] && to=$2 ||  read -p "To wallet ? " to
echo "Denoms: upryzm   factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim"
[ -z $3 ] && amount=$3 || read -p "Amount (incl. denom) ? " amount

echo $PWD | pryzmd tx bank send $from $to $amount \
   --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
