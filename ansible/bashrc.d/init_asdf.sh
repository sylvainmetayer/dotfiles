#!/usr/bin/env bash

function init_asdf_light() {
    starshipVersion='0.58.0'
    asdf plugin-add starship
    asdf install starship $starshipVersion
    asdf global starship $starshipVersion
}

function init_asdf() {
    init_asdf_light

    nodeVersion='16.13.1'
    terraformVersion='1.1.2'
    terragruntVersion='0.35.16'
    shellcheckVersion='0.8.0'
    helmVersion='3.7.2'
    yttVersion='0.38.0'
    eksCtlVersion='0.77.0'
    awscliVersion='2.4.7'
    kubectlVersion='1.23.1'
    dockerComposeVersion='1.29.2'
    direnvVersion='2.30.1'
    redisVersion='5.0.13'
    fzfVersion='0.30.0'
    ocVersion='v4.10.0'

    if ! command -v asdf &>/dev/null; then
        echo "asdf could not be found"
        exit 1
    fi

    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs $nodeVersion
    asdf global nodejs $nodeVersion

    asdf plugin-add redis https://github.com/smashedtoatoms/asdf-redis.git
    asdf install redis $redisVersion
    asdf global redis $redisVersion

    asdf plugin-add direnv
    asdf install direnv $direnvVersion
    asdf global direnv $direnvVersion

    asdf plugin-add docker-compose https://github.com/virtualstaticvoid/asdf-docker-compose.git
    asdf install docker-compose $dockerComposeVersion
    asdf global docker-compose $dockerComposeVersion

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

    asdf plugin add kubectx
    asdf plugin add argocd

    asdf plugin add fzf
    asdf install fzf $fzfVersion
    asdf global fzf $fzfVersion

    asdf plugin add operator-sdk

    asdf plugin-add oc https://github.com/bartoszmajsak/asdf-oc.git
    asdf install oc $ocVersion
    asdf global oc $ocVersion

}
