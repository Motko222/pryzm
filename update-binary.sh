#!/bin/bash

read -p "URL? " url
sudo systemctl stop pryzm.service
cd /usr/local/bin
rm pryzmd
wget $url -O pryzmd
chmod +x pryzmd

echo "New binary installed."
