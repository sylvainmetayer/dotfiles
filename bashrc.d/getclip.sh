#!/usr/bin/env bash

# Return the content of the clipboard.
# - Require `xclip`


getclip() {
    xclip -selection c -o
}

