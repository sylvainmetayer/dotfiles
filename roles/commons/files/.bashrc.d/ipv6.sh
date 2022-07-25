#!/usr/bin/env bash

ipv6_off() {
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
}

ipv6_on() {
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0
}
