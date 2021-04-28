#!/usr/bin/env bash

# https://twitter.com/udoyen/status/1156595186191020033?s=09
function define() {
   curl --silent dict://dict.org/d:"$1"
}
