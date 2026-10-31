#!/usr/bin/env bash

# GOP specific
export CHROME_BIN=/usr/bin/chromium-browser

tool_server_id () {
  aws ec2 describe-instances --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-as-tool-server Name=instance-state-name,Values=running
}
sftp_server_id () {
  aws ec2 describe-instances --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-sftp-s3-gateway Name=instance-state-name,Values=running
}

# @see https://github.com/hashicorp/terraform-provider-aws/issues/10491#issuecomment-1228922077
set_aws_creds_tf () {
    local role mfa_arn source_profile otp creds
    if [ -z "${AWS_PROFILE:-}" ]; then
        echo "AWS_PROFILE is not set" >&2
        return 1
    fi
    unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

    role="$( aws configure get role_arn --profile "$AWS_PROFILE" )"
    mfa_arn="$( aws configure get mfa_serial --profile "$AWS_PROFILE" )"
    source_profile="$( aws configure get source_profile --profile "$AWS_PROFILE" )"
    echo "Enter OTP to allow define credentials for Terraform on account $AWS_PROFILE"
    read -r otp
    creds="$(aws --profile "$source_profile" sts assume-role --role-arn "$role" --role-session-name set-aws-creds-session-tf --serial-number "$mfa_arn" --token-code "$otp" --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)" || return 1
    read -r AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< "$creds"
    export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

# require by rust installed with asdf
#RUST_VERSION=1.70.0
#test -f $HOME/.asdf/install/rust/$RUST_VERSION/env &&  source /home/s.metayer/.asdf/installs/rust/$RUST_VERSION/env

#test -d $HOME/.asdf/installs/gcloud && source /home/s.metayer/.asdf/installs/gcloud/$(gcloud --version | head -n 1 | cut -d" " -f 4)/path.bash.inc
#test -d $HOME/.asdf/installs/gcloud && source /home/s.metayer/.asdf/installs/gcloud/$(gcloud --version | head -n 1 | cut -d" " -f 4)/completion.bash.inc

alias kk="EDITOR='code --wait' k9s"

alias tf_lock="terragrunt providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=darwin_amd64"

#export USE_GKE_GCLOUD_AUTH_PLUGIN=False

