#!/bin/bash

source ~/scripts/pryzm/config/env

if [ -z $1 ]
then
 read -p "From key or wallet ? " from
else
 from=$1
fi

if [ -z $2 ]
then
 read -p "To wallet ? " to
else
 to=$2
fi

echo "Denoms: upryzm   factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim"

[ -z $3 ] && read -p "Amount (incl. denom) ? " amount || amount=$3

echo $PWD | pryzmd tx bank send $from $to $amount \
   --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
