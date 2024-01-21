#!/bin/bash

source ~/scripts/pryzm/config/env

if [ -z $1 ]
then
 read -p "From wallet ? " from
else
 from=$1
fi

if [ -z $2 ]
then
 read -p "To wallet ? " to
else
 to=$2
fi

if [ -z $3 ]
then
 read -p "Amount (incl. denom) ? " amount
else
 amount=$3
fi

#amount=$(echo $amount | awk '{print  $1 * 1000000}' )ubbn

pryzmd tx bank send $from $to $amount \
   --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
