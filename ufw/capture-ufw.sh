#!/bin/bash
# 	ufw/capture-ufw.sh  3.242.699  2019-04-16T21:38:47.409701-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.241-5-g26b5e67  
# 	   first ruff out still more needed 
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
#       Copyright (c) 2019 Bradley Allen
#       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 1.0 DEBUG variable
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#       set -x
#       set -v
BOLD=$(tput -Txterm bold)
NORMAL=$(tput -Txterm sgr0)
### production standard 7.0 Default variable value
DEFAULT_CLUSTER=""
DEFAULT_USER=${USER}
DEFAULT_DATA_DIR="/usr/local/data/"
### production standard 0.1.166 --help
display_help() {
echo -e "\n${NORMAL}${0} - brief description"
echo -e "\nUSAGE"
echo    "   ${0} [XX | YY | ZZ]"
echo    "   ${0} [--file <PATH>/<FILE_NAME> | -f <PATH>/<FILE_NAME>]"
echo    "   ${0} [<REGISTRY_HOST>]"
echo    "   ${0}  <REGISTRY_HOST> [<REGISTRY_PORT>]"
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT> [<CLUSTER>]"
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER> [<DATA_DIR>]"
echo    "   ${0}  <REGISTRY_HOST>  <REGISTRY_PORT>  <CLUSTER>  <DATA_DIR> [<SYSTEMS_FILE>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "<your help goes here>"
echo    ">>> NEED TO COMPLETE THIS SOON, ONCE I KNOW HOW IT IS GOING TO WORK :-) <<<    |"
echo -e "\n<<Paragraph two>>"

echo -e "\nThe <DATA_DIR>/<CLUSTER>/<SYSTEMS_FILE> includes one FQDN or IP address per"
echo    "line for all hosts in the cluster.  Lines in <SYSTEMS_FILE> that begin with a"
echo    "'#' are comments.  The <SYSTEMS_FILE> is used by markit/find-code.sh,"
echo    "Linux-admin/cluster-command/cluster-command.sh, docker-TLS/copy-registry-tls.sh,"
echo    "pi-display/create-message/create-display-message.sh, and other scripts.  A"
echo    "different <SYSTEMS_FILE> can be entered on the command line or environment"
echo    "variable."

echo -e "\nThis script works for the local host only.  To use check-host-tls.sh on a"
echo    "remote hosts (one-rpi3b.cptx86.com) with ssh port of 12323 as uadmin user;"
echo -e "\t${BOLD}ssh -tp 12323 uadmin@one-rpi3b.cptx86.com 'sudo check-host-tls.sh'${NORMAL}"

echo    "To loop through a list of hosts in the cluster use,"
echo    "https://github.com/BradleyA/Linux-admin/tree/master/cluster-command"
echo -e "\t${BOLD}cluster-command.sh special 'sudo check-host-tls.sh'${NORMAL}"

echo -e "\nThe administration user may receive password and/or passphrase prompts from a"
echo    "remote systen; running the following may stop the prompts in your cluster."
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<REMOTE_HOST>${NORMAL}"
echo    "or"
echo -e "\t${BOLD}ssh-copy-id <TLS_USER>@<192.168.x.x>${NORMAL}"

### production standard 4.0 Documentation Language
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nENVIRONMENT VARIABLES"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG           (default off '0')"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"
echo    "   SYSTEMS_FILE    Hosts in cluster (default '${DEFAULT_SYSTEMS_FILE}')"
echo -e "\nOPTIONS"
echo    "   -f, --file      path and file on system '<path>/<file_name>'"
echo -e "\nOPTIONS"
echo    "Order of precedence: CLI options, environment variable, default code."
echo -e "   <<your environment variables information goes here>>"
echo    "   CLUSTER         Cluster name (default '${DEFAULT_CLUSTER}')"
echo    "   DATA_DIR        Data directory (default '${DEFAULT_DATA_DIR}')"
echo    "   SYSTEMS_FILE    Hosts in cluster (default '${DEFAULT_SYSTEMS_FILE}')"


us-tx-cluster-1/o
n standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION


