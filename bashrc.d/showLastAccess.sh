#!/usr/bin/env bash

# Show the 10 last access for every nginx site configured.
# - require that your log files are named with the following convention `name.access.log`

showLastAccess() {
    sudo tail -n 10 /var/log/nginx/*.access.log
}

