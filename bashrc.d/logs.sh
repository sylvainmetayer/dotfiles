#!/usr/bin/env bash

# eg. NetworkManager, sssd
log_service() {
  journalctl -eu "$1"
}

