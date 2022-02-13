#!/bin/bash

set -e
set -o pipefail

source "./lib.bash"

info "Checking DB Instances"
aws rds describe-db-instances --query 'DBInstances[?!DeletionProtection].[DBInstanceIdentifier]' --output text | \
while read line; do
  if [[ "${line}" != *"None"* ]]; then
    info "  ${line}"
    db_cluster_id=$(aws rds describe-db-instances --db-instance-identifier "${line}" --query 'DBInstances[?DBClusterIdentifier].[DBClusterIdentifier]' --output text)
    if [[ -n ${db_cluster_id} ]]; then
      info "${line} is part of a cluster, deletion protection will be set in the next loop, if required."
    else
      plain "  aws rds modify-db-instance --no-cli-pager --db-instance-identifier ${line} --deletion-protection"
      if [[ -n "${REMEDIATE:-}" ]]; then
        info "Remediating ..."
        aws rds modify-db-instance --no-cli-pager --db-instance-identifier "${line}" --deletion-protection
      fi
    fi
  fi
done

info "Checking DB Clusters"
aws rds describe-db-clusters --query 'DBInstances[?!DeletionProtection].[DBInstanceIdentifier]' --output text | \
while read line; do
  if [[ "${line}" != *"None"* ]]; then
    info "  ${line}"
    plain "  aws rds modify-db-cluster --no-cli-pager --db-instance-identifier ${line} --deletion-protection"
    if [[ -n "${REMEDIATE:-}" ]]; then
      info "Remediating ..."
      aws rds modify-db-cluster --no-cli-pager --db-instance-identifier "${line}" --deletion-protection
    fi
  fi
done
