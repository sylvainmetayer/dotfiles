#!/usr/bin/env bash

function init_asdf() {
    nodeVersion='15.2.0'
    starshipVersion='0.46.2'
    if ! command -v asdf &>/dev/null; then
        echo "COMMAND could not be found"
        exit
    fi
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
    asdf install nodejs $nodeVersion
    asdf global nodejs $nodeVersion
    asdf plugin add starship
    asdf install starship $starshipVersion
    asdf global starship $starshipVersion
}
