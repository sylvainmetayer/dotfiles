#!/usr/bin/env bash

# GOP specific
export CHROME_BIN=/usr/bin/chromium-browser

tool_server_id () {
  aws ec2 describe-instances --query 'Name' --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-as-tool-server Name=instance-state-name,Values=running
}
sftp_server_id () {
  aws ec2 describe-instances --query 'Name' --query 'Reservations[0].Instances[0].[{Instance:InstanceId}][0].Instance' --output json --filters Name=tag:Name,Values=*-sftp-s3-gateway Name=instance-state-name,Values=running
}

