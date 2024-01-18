#!/bin/bash

sudo journalctl -u pryzm.service -f --no-hostname -o cat
