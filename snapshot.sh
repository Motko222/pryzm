#!/bin/bash

read -p "Are you sure? " answer
case $answer in
  y|Y|yes|YES) echo "Restoring from snapshot..." ;;
  *) exit 1 ;;
esac

#stop service
sudo systemctl stop pryzm.service

# Backup the priv_validator_state
cp $HOME/.pryzm/data/priv_validator_state.json $HOME/.pryzm/priv_validator_state.json.backup

# Reset the node
rm -rf $HOME/.pryzm/data
rm -rf $HOME/.pryzm/wasm
pryzmd tendermint unsafe-reset-all --home $HOME/.pryzm --keep-addr-book

# Configure pruning and indexer
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.pryzm/config/config.toml

# Disable state sync
sed -i -e "s/^enable *=.*/enable = false/" $HOME/.pryzm/config/config.toml

curl https://snapshots.spacestake.tech/testnet-snapshots/pryzm/latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.pryzm

# Restore the priv_validator_state
mv $HOME/.pryzm/priv_validator_state.json.backup $HOME/.pryzm/data/priv_validator_state.json

echo "Snapshot restore finished, start the node."
