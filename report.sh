#!/bin/bash

source ~/scripts/pryzm/config/env
json=$(curl -s localhost:26657/status | jq .result.sync_info)

pid=$(pgrep pryzmd)
ver=$(pryzmd version)
network=$(pryzmd status | jq -r .NodeInfo.network)
type="validator"
foldersize1=$(du -hs ~/.pryzm | awk '{print $1}')
foldersize2=$(du -hs ~/pryzm | awk '{print $1}')
latestBlock=$(echo $json | jq -r .latest_block_height)
catchingUp=$(echo $json | jq -r .catching_up)
votingPower=$(pryzmd status 2>&1 | jq -r .ValidatorInfo.VotingPower)
delegators=$(pryzmd query staking delegations-to $VALOPER -o json | jq '.delegation_responses | length')
jailed=$(pryzmd query staking validator $VALOPER -o json | jq -r .jailed)
if [ -z $jailed ]; then jailed=false; fi
tokens=$(pryzmd query staking validator $VALOPER -o json | jq -r .tokens | awk '{print $1/1000000}')
balance=$(pryzmd query bank balances $WALLET | grep amount | awk '{print $3}' | sed 's/"//g' | awk '{print $1 / 1000000}' )

if $catchingUp
 then 
  status="warning"
  note="height=$latestBlock"
 else 
  status="ok"
  note="del $delegators | vp $tokens | bal $balance | bls $(date -d $bls +'%y-%m-%d %H:%M')"
fi

if $jailed
 then
  status="warning"
  note="jailed"
fi 

if [ -z $pid ];
then status="error";
 note="not running";
fi

echo "updated='$(date +'%y-%m-%d %H:%M')'"
echo "version='$ver'"
echo "process='$pid'"
echo "status="$status
echo "note='$note'"
echo "network='$network'"
echo "type="$type
echo "folder1=$foldersize1"
echo "folder2=$foldersize2"
#echo "log=$logsize" 
echo "id=$MONIKER" 
echo "key=$KEY"
echo "wallet=$WALLET"
echo "catchingUp=$catchingUp"
echo "jailed=$jailed"
echo "height=$latestBlock"
echo "votingPower=$votingPower"
echo "tokens=$tokens"
echo "delegators=$delegators"
echo "balance=$balance"
echo "bls="$bls
