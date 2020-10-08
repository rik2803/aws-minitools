#! /bin/bash

[[ -z ${1} ]] && { echo "Usage: ${0} <user> Active|Inactive"; exit 1; } 
[[ -z ${2} ]] && { echo "Usage: ${0} <user> Active|Inactive"; exit 1; } 
[[ ${2} == "Active" || ${2} == "Inactive" ]] || { echo "Usage: ${0} <user> Active|Inactive"; exit 1; } 

for access_key in $(aws iam list-access-keys --user ${1} --query 'AccessKeyMetadata[].AccessKeyId[]' --output text); do
  aws iam update-access-key --user ${1} --access-key-id ${access_key} --status ${2}
done

