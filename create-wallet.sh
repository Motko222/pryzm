#!/bin/bash

if [ -z $1 ]
then
 read -p "Key name ? " key
else
 key=$1
fi

pryzmd keys add $key
