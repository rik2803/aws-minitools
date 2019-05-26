#! /usr/bin/env bash

# Deletes CW Log Groups older than ${1:-604800} (Default is 1 week)

[[ -z ${1} ]] && { echo "ERROR: Expect string that matches log group name"; exit 1; }
str_to_match=${1}

args=$(aws logs  describe-log-groups --query 'logGroups[*].[logGroupName,creationTime][]' --output text)
now=$(date +"%s")
let "now = ${now} * 1000"
max_age=${2:-604800}
let "max_age = ${max_age} * 1000"


set -- ${args}
loggroup=${1}; shift
creationtime=${1}; shift

while [[ -n ${loggroup} ]]; do
  let "delta = ${now} - ${creationtime}"
  if [[ ${loggroup} =~ ${str_to_match} ]]; then
    if [[ ${delta} -gt ${max_age} ]]; then
      echo "INFO: Deleting ${loggroup} (${now} - ${creationtime} = ${delta} > ${max_age})"
      aws logs delete-log-group --log-group-name ${loggroup}
    else
      echo "INFO: Skip deletion of ${loggroup} because too young (${now} - ${creationtime} = ${delta} < ${max_age})"
    fi
  else
      echo "INFO: ${loggroup} does not match ${str_to_match}"
  fi
  loggroup=${1}; shift
  creationtime=${1}; shift
done
