#!/bin/bash

source ~/scripts/pryzm/config/env

pryzmd tx staking create-validator \
--amount 20000000upryzm \
--pubkey $(pryzmd tendermint show-validator) \
--moniker $MONIKER \
--identity "ID" \
--details "DETAILS" \
--website "WEBSITE" \
--chain-id indigo-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from $WALLET \
--gas-adjustment 1.4 \
--gas auto \
--fees 10upryzm \
-y
