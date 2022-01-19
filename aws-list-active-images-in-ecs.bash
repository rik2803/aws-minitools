#! /usr/bin/env bash

usage() {
  cat << EOF
    Show all active ECS services and all docker images used in each of those services.

      Message: ${1:-No details available}
      Usage: ${0} ecs-cluster-name
EOF
}

get_cluster_services() {
  aws ecs list-services --cluster "${1}" --query 'serviceArns[*]' --output text
}

get_task_definition() {
  aws ecs describe-services \
                       --cluster "${1}" \
                       --services "${2}" \
                       --query 'services[*].taskDefinition' \
                       --output text
}

get_images_for_taskdefinition() {
  aws ecs describe-task-definition --task-definition "${1}" \
                                   --query 'taskDefinition.containerDefinitions[*].image' \
                                   --output text
}

service_arn_to_service() {
  echo "${1##*/}"
}

image_uri_to_image_name_and_version() {
  echo "${1##*/}"
}

gray="\\e[37m"
blue="\\e[36m"
red="\\e[31m"
green="\\e[32m"
orange="\\e[33m"
reset="\\e[0m"

info()    { echo -e "${blue}INFO: $*${reset}" 1>&2; }
warning() { echo -e "${orange}WARN: $*${reset}" 1>&2; }
plain()   { echo -e "${green}$*${reset}"; }
error()   { echo -e "${red}ERROR: $*${reset}" 1>&2; }
success() { echo -e "${green}✔ $*${reset}" 1>&2; }
fail()    { echo -e "${red}✖ $*${reset}" 1>&2; exit 1; }
debug()   { [[ "${DEBUG}" == "true" ]] && echo -e "${gray}DEBUG: $*${reset}"  1>&2 || true; }

### Validate input
aws sts get-caller-identity >/dev/null 2>&1 || { usage "No active AWS credentials"; exit 1; }
[[ -z ${1} ]] && { usage "First argument should be ECS cluster name"; exit 1; }

### Action!!
cluster=${1}; shift

###
for service in $(get_cluster_services "${cluster}"); do
  debug "${service}"
  taskdefinition=$(get_task_definition "${cluster}" "${service}")
  debug "${taskdefinition}"
  images=$(get_images_for_taskdefinition "${taskdefinition}")
  for image in ${images}; do
    debug "${image}"
    plain "$(service_arn_to_service "${service}"): $(image_uri_to_image_name_and_version "${image}")"
  done
done

