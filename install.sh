#!/bin/bash

# Create config file
if [ -f ~/scripts/pryzm/config/env ]
 then
   echo "Config file found."
 else
   read -p "Key name? " KEY
   read -p "Moniker name? " MONIKER
   echo "KEY="$KEY > ~/scripts/pryzm/config/env
   echo "MONIKER="$MONIKER >> ~/scripts/pryzm/config/env
   echo "Config file created."
fi

# Download binary
read -p "URL? " url

# wipe
rm -r ~/.pryzm
wget $url -O pryzmd
chmod +x pryzmd
mv pryzmd /usr/local/bin/pryzmd

# Set node configuration
pryzmd config chain-id indigo-1
#pryzm config keyring-backend test
pryzmd config node tcp://localhost:26656

# Initialize the node
pryzmd init $MONIKER --chain-id indigo-1

# Download genesis
curl -Ls https://storage.googleapis.com/pryzm-zone/indigo-1/genesis.json > $HOME/.pryzm/config/genesis.json

# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"ff17ca4f46230306412ff5c0f5e85439ee5136f0@testnet-seed.pryzm.zone:26656\"|" $HOME/.pryzm/config/config.toml

# Add persistent_peers
#peers=""
#sed -i -e "s|^persistent_peers *=.*|persistent_peers = \"$peers\"|" $HOME/.pryzm/config/config.toml

# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.015upryzm, 0.01factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim\"|" $HOME/.pryzm/config/app.toml

# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.pryzm/config/app.toml

# Set custom ports
#sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:16458\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:16457\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:16460\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:16456\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":16466\"%" $HOME/.pryzm/config/config.toml
#sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:16417\"%; s%^address = \":8080\"%address = \":16480\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:16490\"%; s%^address = \"localhost:9091\"%address = \"0.0.0.0:16491\"%; s%:8545%:16445%; s%:8546%:16446%; s%:6065%:16465%" $HOME/.pryzm/config/app.toml

# Download latest chain snapshot
#curl -L https://snap.nodex.one/pryzm-testnet/pryzm-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.pryzm
curl -L http://37.120.189.81/pryzm_testnet/pryzm_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.pryzm
#[[ -f $HOME/.pryzm/data/upgrade-info.json ]] && cp $HOME/.pryzm/data/upgrade-info.json $HOME/.pryzm/cosmovisor/genesis/upgrade-info.json

#create service
sudo tee /etc/systemd/system/pryzm.service > /dev/null << EOF
[Unit]
Description=pryzm node service
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/pryzmd start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=/root/.pryzm"
Environment="DAEMON_NAME=pryzm"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pryzm.service

echo "Installation done, service is not started. Please run it with start.sh."
