#!/usr/bin/env bash

load_env() {
  if [ -f .env ]; then
    # We do not want to quote variable or they will assigned as one variable only.
    # shellcheck disable=SC2046
    export $(sed 's/#.*//g' < .env | xargs)
  else
    echo "No .env file found in $(pwd)"
    exit 1
  fi
}
