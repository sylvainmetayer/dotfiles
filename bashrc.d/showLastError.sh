#!/usr/bin/env bash

# Show the last 10 errors for every nginx site configured.
# - require that your log files are named with the following convention `name.error.log`

showLastError() {
    sudo tail -n 10 /var/log/nginx/*.error.log
}
