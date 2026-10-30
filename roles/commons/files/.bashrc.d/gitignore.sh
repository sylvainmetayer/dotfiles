#!/usr/bin/env bash

# Use [Gitignore.io](https://gitignore.io) to generate a .gitignore. Output to stdout.

gitignore() {
    curl --proto '=https' --tlsv1.2 -L -s "https://www.gitignore.io/api/$*"
}

