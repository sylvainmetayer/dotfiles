#!/usr/bin/env bash

fixRights() {
    sudo chown -R "$(id -u):$(id -g)" .
}
