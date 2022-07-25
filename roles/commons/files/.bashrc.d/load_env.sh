#!/usr/bin/env bash

load_env() {
  file=${1:-.env}
  if [ -f "$file" ]; then
    # We do not want to quote variable or they will assigned as one variable only.
    # shellcheck disable=SC2046
    export $(sed 's/#.*//g' < "$file" | sed '/^$/d' | tr "\n" " ")
  else
    echo "No ${file} file found in $(pwd)"
  fi
}
