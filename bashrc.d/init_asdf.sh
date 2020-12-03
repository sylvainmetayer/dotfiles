#!/usr/bin/env bash

function init_asdf() {
    nodeVersion='14.15.0'
    starshipVersion='0.46.2'
    terraformVersion='0.13.5'

    if ! command -v asdf &>/dev/null; then
        echo "COMMAND could not be found"
        exit
    fi

    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
    asdf install nodejs $nodeVersion
    asdf global nodejs $nodeVersion

    asdf plugin-add starship
    asdf install starship $starshipVersion
    asdf global starship $starshipVersion

    asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
    asdf install terraform $terraformVersion
    asdf global terraform $terraformVersion

    asdf plugin-add terragrunt https://github.com/lotia/asdf-terragrunt
    asdf install terragrunt latest
    # Maybe not working at first
    asdf global terragrunt "$(asdf current terragrunt | xargs | cut -d" " -f 2)"

    #asdf plugin-add docker-slim https://github.com/everpeace/asdf-docker-slim.git
    #asdf install docker-slim $dockerSlimVersion
    #asdf global docker-slim $dockerSlimVersion

    asdf plugin-add shellcheck
    asdf install shellcheck latest
    # Maybe not working at first
    asdf global shellcheck "$(asdf current shellcheck | xargs | cut -d" " -f 2)"

    asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
    asdf install helm 3.4.1
    asdf global helm 3.4.1
}
