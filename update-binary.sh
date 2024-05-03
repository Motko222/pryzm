#!/bin/bash

read -p "Sure ? " sure
if [ $sure -ne "y" -a $sure -ne "Y" ]; then exit 1; fi

read -p "URL? " url

cd /usr/local/bin
rm pryzmd
wget $url -o pryzmd
chmod +x pryzmd

echo "New binary installed."
