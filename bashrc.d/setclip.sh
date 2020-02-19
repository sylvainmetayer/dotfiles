#!/usr/bin/env bash

# Set the content of the clipboard. Mean to be use with a pipe. 
# Example : `echo "test" | setclip`
# - Require `xclip`


setclip() {
    xclip -selection c
}

