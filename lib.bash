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
