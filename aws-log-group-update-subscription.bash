#!/bin/bash

set -e
set -o pipefail

source "./lib.bash"

[[ -z "${1}" ]] && fail "Expect lambda ARN of new subscription filter as argument"

lambda_arn="${1}"
dirname=$(dirname ${0})
. ${dirname}/./lib.bash

for loggroup in $(aws logs  describe-log-groups --query 'logGroups[*].[logGroupName][]' --output text); do
  info "Loggroup (start): ${loggroup}"
  for filter in $(aws logs describe-subscription-filters --log-group-name "${loggroup}" --query 'subscriptionFilters[*].filterName' --output text); do
    info "    Filter: ${filter}"
    info "    Delete existing subscription filter ..."
    aws logs delete-subscription-filter --log-group-name "${loggroup}" --filter-name "${filter}"
    info "    Adding new subscription filter for lambda ${lambda_arn}"
    aws logs put-subscription-filter --log-group-name "${loggroup}" --destination-arn "${lambda_arn}" --filter-name "SubscriptionFilter" --filter-pattern ""
  done
  info "Loggroup (end): ${loggroup}"
done


