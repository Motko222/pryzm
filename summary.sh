#!/bin/bash

source ~/scripts/pryzm/config/env

echo   "---- SUMMARY --------------------------------------------------------------------------"
printf "%12s %12s %12s %12 %12s\n" Id Balance1 Balance2 Delegated1 Rewards1 Rewards2
echo   "---------------------------------------------------------------------------------------"

echo $PWD | pryzmd keys list | grep -E 'name|address' | sed 's/- address: //g' | sed 's/  name: //g' | paste - - | grep -v master >~/scripts/pryzm/config/keys

cat ~/scripts/pryzm/config/keys | while read line
do
   id=$(echo $line | awk '{print $2}')
   wallet=$(echo $line | awk '{print $1}')
   balance1=$(pryzmd query bank balances $wallet -o json \
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount)
   balance2=$(pryzmd query bank balances $wallet -o json \
      | jq -r '.balances[] | select(.denom=="factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim")' | jq -r .amount)
   
   #valoper=$(pryzmd keys show $WALLET --bech val | grep valoper | awk '{print $3}')

   rewards1=$(pryzmd query distribution rewards $wallet $VALOPER -o json \
      | jq -r '.rewards[] | select(.denom=="upryzm")' | jq -r .amount)
   
   rewards2=$(pryzmd query distribution rewards $wallet $VALOPER -o json \
      | jq -r '.rewards[] | select(.denom=="factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim")' | jq -r .amount)
   
   delegated1=$(pryzmd query staking delegation $wallet $VALOPER -o json \
      | jq -r .balance.amount)

   printf "%12s %12s %12s %12s %12s\n" \
      $id $balance $stake $rewards
done
