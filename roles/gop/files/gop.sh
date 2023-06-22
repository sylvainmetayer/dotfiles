#!/usr/bin/env bash

# GOP specific
export CHROME_BIN=/usr/bin/chromium-browser

tool_server_id () {
  aws ec2 describe-instances --query 'Name' --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-as-tool-server Name=instance-state-name,Values=running
}
sftp_server_id () {
  aws ec2 describe-instances --query 'Name' --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-sftp-s3-gateway Name=instance-state-name,Values=running
}

# @see https://github.com/hashicorp/terraform-provider-aws/issues/10491#issuecomment-1228922077
set_aws_creds_tf () {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    ROLE="$( aws configure get role_arn --profile $AWS_PROFILE )"
    MFA_ARN="$( aws configure get mfa_serial --profile $AWS_PROFILE )"
    SOURCE_PROFILE="$( aws configure get source_profile --profile $AWS_PROFILE )"
    echo "Enter OTP to allow define credentials for Terraform on account $AWS_PROFILE"
    read -r OTP
    read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< $(aws --profile "$SOURCE_PROFILE" sts assume-role --role-arn "$ROLE" --role-session-name set-aws-creds-session-tf --output text --serial-number "$MFA_ARN" --token-code "$OTP" | awk '/^CREDENTIALS/ {print $2, $4, $5 }')
    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
}

# require by rust installed with asdf
source /home/s.metayer/.asdf/installs/rust/1.70.0/env
