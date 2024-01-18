#!/bin/bash

cd ~/scripts/pryzm
git stash push --include-untracked
git pull
chmod +x *.sh
