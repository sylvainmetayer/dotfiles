#!/usr/bin/env bash

# Use [Gitignore.io](https://gitignore.io) to generate a .gitignore. Output to stdout.

gitignore() {
    curl -L -s "https://www.gitignore.io/api/$*"
}

