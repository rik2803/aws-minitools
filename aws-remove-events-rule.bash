#! /usr/bin/env bash

usage() {
  cat << EOF
    Remove an AWS event rule

      Message: ${1:-No details available}
      Usage: ${0} rulenamesubstring
EOF
}

dirname=$(dirname ${0})
. ${dirname}/./lib.bash

## ${1} contains a string to look for in the rule name
[[ -n "${1}" ]] || fail "Pass part of the name of the rule as argument"

rule_name_substring="${1}"
rule_name="$(aws events list-rules | jq -r '.Rules[].Name' | grep "${rule_name_substring}")"
[[ -n "${rule_name}" ]] || fail "No rule found containing \"${rule_name_substring}\" in it's name."
info "Rule name: ${rule_name}"
rule_targets="$(aws events list-targets-by-rule --rule "${rule_name}" | jq -r '.Targets[].Id')"
info "Rule targets:${rule_targets}"

for rule_target in ${rule_targets}; do
  aws events remove-targets --rule "${rule_name}" --ids "${rule_target}"
done

aws events delete-rule --name "${rule_name}"
