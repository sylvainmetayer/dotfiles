#!/usr/bin/env bash

function init_asdf_light() {
    starshipVersion='0.58.0'
    asdf plugin-add starship
    asdf install starship $starshipVersion
    asdf global starship $starshipVersion
}

function init_asdf() {
    init_asdf_light

    nodeVersion='14.17.0'
    terraformVersion='1.0.8'
    terragruntVersion='0.34.0'
    shellcheckVersion='0.7.2'
    helmVersion='3.7.0'
    yttVersion='0.36.0'
    eksCtlVersion='0.68.0'
    awscliVersion='2.2.43'
    kubectlVersion='1.22.2'

    if ! command -v asdf &>/dev/null; then
        echo "asdf could not be found"
        exit 1
    fi

    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
    asdf install nodejs $nodeVersion
    asdf global nodejs $nodeVersion

    asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
    asdf install terraform $terraformVersion
    asdf global terraform $terraformVersion

    asdf plugin-add terragrunt https://github.com/lotia/asdf-terragrunt
    asdf install terragrunt $terragruntVersion
    asdf global terragrunt $terragruntVersion

    asdf plugin-add shellcheck
    asdf install shellcheck $shellcheckVersion
    asdf global shellcheck $shellcheckVersion

    asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
    asdf install helm $helmVersion
    asdf global helm $helmVersion

    asdf plugin add ytt https://github.com/sylvainmetayer/asdf-ytt
    asdf install ytt $yttVersion
    asdf global ytt $yttVersion

    asdf plugin-add eksctl
    asdf install eksctl $eksCtlVersion
    asdf global eksctl $eksCtlVersion

    asdf plugin add kubectl
    asdf install kubectl $kubectlVersion
    asdf global kubectl $kubectlVersion

    asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git
    asdf install awscli $awscliVersion
    asdf global awscli $awscliVersion
}
