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
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount')
balance2=$(pryzmd query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim")' | jq -r .amount')
echo "Balance: $balance1 upryzm, $balance2 uusdsim"

if [ -z $2 ]
then
 read -p "Pool id (default 3) ? " pool_id
 if [ -z $pool_id ]; then pool_id=3; fi
else
 pool_id=$2
fi

if [ -z $3 ]
then
 read -p "Amount (u) ? " amount
else
 amount=$3
fi

if [ -z $4 ]
then
 read -p "Token in (uusdsim) ? " token_in
 if [ -z $token_in ]; then token_in=factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim; fi
else
 token_in=$4
fi

if [ -z $5 ]
then
 read -p "Token out (upryzm) ? " token_out
 if [ -z $token_in ]; then token_out=upryzm; fi
else
 token_out=$5
fi

echo $PWD | pryzmd tx amm single-swap '{ "amount": "'$amount'", "pool_id": '$pool_id', "token_in": "'$token_in'", "token_out": "'$token_out'" }' \
   --from $key --gas-prices 0.1upryzm --gas-adjustment 1.5 --gas auto -y
