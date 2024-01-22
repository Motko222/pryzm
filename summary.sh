#!/bin/bash

source ~/scripts/pryzm/config/env

echo   "---- SUMMARY --------------------------------------------------------------------------"
printf "%-12s %9s %9s %-30s\n" Id Balance Delegated Reward
echo   "---------------------------------------------------------------------------------------"

echo $PWD | pryzmd keys list | grep -E 'name|address' | sed 's/- address: //g' | sed 's/  name: //g' | paste - - | grep -v master >~/scripts/pryzm/config/keys

cat ~/scripts/pryzm/config/keys | while read line
do
   id=$(echo $line | awk '{print $2}')
   wallet=$(echo $line | awk '{print $1}')
   balance=$(pryzmd query bank balances $wallet | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   #valoper=$(pryzmd keys show $WALLET --bech val | grep valoper | awk '{print $3}')
   rewards=$(pryzmd query distribution rewards $wallet $VALOPER 2>/dev/null \
     | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1/1000000}')
   
   stake=$(pryzmd query staking delegation $wallet $VALOPER 2>/dev/null \
     | grep amount | awk '{print $2}' | sed 's/"//g' | awk '{print $1/1000000}' )

   printf "%-12s %9s %9s %14s %14s\n" \
      $id $balance $stake $rewards
done
