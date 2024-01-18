#!/bin/bash

sudo systemctl restart pryzm.service
sudo journalctl -u pryzm.service -f --no-hostname -o cat
