#! /usr/bin/env bash


function get_sg_id {
 echo $(aws ec2 describe-security-groups --query "SecurityGroups[*]|[?contains(GroupName,'${1}')].GroupId" --output text 2>/dev/null | tail -1 | awk '{print $1}')
}

[[ -z ${1} ]] && { echo "Usage: ${0} sgname authorize|revoke port sourceCIDR"; exit 1; }
[[ -z ${2} ]] && { echo "Usage: ${0} sgname authorize|revoke port sourceCIDR"; exit 1; }
[[ -z ${3} ]] && { echo "Usage: ${0} sgname authorize|revoke port sourceCIDR"; exit 1; }
[[ -z ${4} ]] && { echo "Usage: ${0} sgname authorize|revoke port sourceCIDR"; exit 1; }
[[ ${2} == +(authorize|revoke) ]] || { echo "Usage: ${0} sgname authorize|revoke port sourceCIDR"; exit 1; }

aws ec2 ${2}-security-group-ingress --group-id $(get_sg_id ${1}) --protocol tcp --port ${3} --cidr ${4}
