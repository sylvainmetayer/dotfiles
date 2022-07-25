#!/usr/bin/env bash

roles=('commons' 'docker' 'fedora_dependencies' 'git_config' 'git_credential_keepassxc' 'gnome' 'gop' 'hostname' 'jetbrains_toolbox' 'kdrive' 'ledger' 'ssh_config')

for role in "${roles[@]}"; do
  mkdir -p "roles/$role/meta"
  cp ./scripts/templates/main.yml "roles/$role/meta/"
  cp ./scripts/templates/README.md "roles/$role/"
  sed -i "s/ROLE_NAME/$role/" "roles/$role/meta/main.yml"
  sed -i "s/ROLE_NAME/$role/" "roles/$role/README.md"
done
