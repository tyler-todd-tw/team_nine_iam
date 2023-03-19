#!/usr/bin/env bash
export ENVIRONMENT=$1
export AWS_ACCOUNT_ID=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .account_id)

aws sts assume-role --output json --role-arn arn:aws:iam::${AWS_ACCOUNT_ID}:role/DPSIamProfilesRole --role-session-name awspec-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")
export AWS_DEFAULT_REGION=$(cat ${ENVIRONMENT}.auto.tfvars.json | jq -r .aws_region)

inspec exec test/iam-roles -t aws://

if [[ ${ENVIRONMENT} == "nonprod" ]]; then
  inspec exec test/iam-profiles -t aws://
fi
