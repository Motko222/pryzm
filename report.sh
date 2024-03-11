#!/bin/bash

source ~/.bash_profile
json=$(curl -s localhost:26657/status | jq .result.sync_info)

pid=$(pgrep pryzmd)
ver=$(pryzmd version)
chain=$(pryzmd status | jq -r .NodeInfo.network)
type="validator"
foldersize1=$(du -hs ~/.pryzm | awk '{print $1}')
#foldersize2=$(du -hs ~/pryzm | awk '{print $1}')
latestBlock=$(echo $json | jq -r .latest_block_height)
catchingUp=$(echo $json | jq -r .catching_up)
votingPower=$(pryzmd status 2>&1 | jq -r .ValidatorInfo.VotingPower)
wallet=$(echo $PRYZM_PWD | pryzmd keys show $PRYZM_KEY -a)
valoper=$(echo $PRYZM_PWD | pryzmd keys show $PRYZM_KEY -a --bech val)
pubkey=$(pryzmd tendermint show-validator --log_format json | jq -r .key)
delegators=$(pryzmd query staking delegations-to $valoper -o json | jq '.delegation_responses | length')
jailed=$(pryzmd query staking validator $valoper -o json | jq -r .jailed)
if [ -z $jailed ]; then jailed=false; fi
tokens=$(pryzmd query staking validator $valoper -o json | jq -r .tokens | awk '{print $1/1000000}')
balance=$(pryzmd query bank balances $wallet -o json 2>/dev/null \
      | jq -r '.balances[] | select(.denom=="upryzm")' | jq -r .amount | awk '{print $1/1000000}')
active=$(pryzmd query tendermint-validator-set | grep -c $pubkey)
threshold=$(pryzmd query tendermint-validator-set -o json | jq -r .validators[].voting_power | tail -1)
bucket=validator
id=pryzm-$PRYZM_ID
moniker=$PRYZM_MONIKER
project=pryzm

if $catchingUp
 then 
  status="syncing"
  message="height=$latestBlock"
 else 
  if [ $active -eq 1 ]; then status=active; else status=inactive; fi
  #message="act $active | del $delegators | vp $tokens | thr $threshold | bal $balance"
fi

if $jailed
 then
  status="jailed"
  #message="jailed"
fi 

if [ -z $pid ];
then status="offline";
 message="process not running";
fi

echo "updated='$(date +'%y-%m-%d %H:%M')'"
echo "version='$ver'"
echo "process='$pid'"
echo "status="$status
echo "message='$message'"
echo "chain='$chain'"
echo "type="$type
echo "folder1=$foldersize1"
#echo "folder2=$foldersize2"
#echo "log=$logsize" 
echo "id=$id" 
echo "key=$PRYZM_KEY"
echo "wallet=$wallet"
echo "valoper=$valoper"
echo "pubkey=$pubkey"
echo "catchingUp=$catchingUp"
echo "jailed=$jailed"
echo "active=$active"
echo "height=$latestBlock"
echo "votingPower=$votingPower"
echo "tokens=$tokens"
echo "threshold=$threshold"
echo "delegators=$delegators"
echo "balance=$balance"

# send data to influxdb
if [ ! -z $INFLUX_HOST ]
then
 curl --request POST \
 "$INFLUX_HOST/api/v2/write?org=$INFLUX_ORG&bucket=$bucket&precision=ns" \
  --header "Authorization: Token $INFLUX_TOKEN" \
  --header "Content-Type: text/plain; charset=utf-8" \
  --header "Accept: application/json" \
  --data-binary "
    status,machine=$MACHINE,id=$id,moniker=$moniker status=\"$status\",message=\"$message\",version=\"$version\",url=\"$url\",chain=\"$chain\",tokens=\"$tokens\",threshold=\"$threshold\",active=\"$active\",jailed=\"$jailed\" $(date +%s%N) 
    "
fi
