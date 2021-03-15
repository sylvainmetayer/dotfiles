#!/usr/bin/env bash

echo "Raspberry PI backup starting"
date

for f in ~/backup/*.sh; do
    echo "$f"
done
