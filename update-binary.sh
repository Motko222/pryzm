#!/bin/bash

read -p "URL? " url

cd /usr/local/bin
rm pryzmd
wget $url -O pryzmd
chmod +x pryzmd

echo "New binary installed."
