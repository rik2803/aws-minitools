#! /usr/bin/env bash

usage() {
  cat << EOF
    Return the account-list of suppressed e-mail accounts

      Message: ${1:-No details available}
      Usage: ${0} [epoch]
EOF
}

epoch=0
dirname=$(dirname ${0})
. ${dirname}/./lib.bash

[[ -n "${1}" ]] && epoch="${1}"

aws sesv2 list-suppressed-destinations --start-date "${epoch}" --region "${AWS_DEFAULT_REGION:-eu-west-1}" > ~/tmp/list-suppressed-destinations${$}

cat ~/tmp/list-suppressed-destinations${$} | jq -r '.SuppressedDestinationSummaries[] | .EmailAddress + ";" + .Reason + ";" + .LastUpdateTime'
next_token=$(cat ~/tmp/list-suppressed-destinations${$} | jq -r '.NextToken')

while [[ ${next_token} != "null" ]]; do
  aws sesv2 list-suppressed-destinations --start-date "${epoch}" --region "${AWS_DEFAULT_REGION:-eu-west-1}" --next-token "${next_token}" > ~/tmp/list-suppressed-destinations${$}
  cat ~/tmp/list-suppressed-destinations${$} | jq -r '.SuppressedDestinationSummaries[] | .EmailAddress + ";" + .Reason + ";" + .LastUpdateTime'
  next_token=$(cat ~/tmp/list-suppressed-destinations${$} | jq -r '.NextToken')
done
