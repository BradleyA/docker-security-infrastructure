#!/bin/bash
# 	ssh/check-user-ssh.sh  3.349.816  2019-07-26T22:53:31.381266-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.348  
# 	   testing post-commit .git/hook for FVT 
# 	ssh/check-user-ssh.sh  3.297.764  2019-07-26T13:23:46.474164-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.296  
# 	   updated display_help OPTIONS section #57 
# 	ssh/check-user-ssh.sh  3.296.763  2019-07-26T12:53:58.770864-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.295  
# 	   updated production standard 8.3.204 --usage #57 
# 	ssh/check-user-ssh.sh  3.268.735  2019-06-08T21:10:21.816373-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.267  
# 	   docker-TLS/c{} - change DEFAULT_USER_HOME="/home/" to ~ #54 
# 	ssh/check-user-ssh.sh  3.249.712  2019-05-31T23:12:12.939731-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.248  
# 	   ssh/check-user-ssh.sh testing complete ready for release 
# 	ssh/check-user-ssh.sh  3.246.709  2019-05-31T11:16:51.943687-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.246-1-gce6599f  
# 	   check-user-ssh.sh usage added production standard 8.0 --usage 
# 	ssh/check-user-ssh.sh  3.246.707  2019-05-18T17:50:55.742880-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.245-4-g6bb0eb9  
# 	   updated ssh-keygen compare public and private keys 
# 	ssh/check-user-ssh.sh  3.241.693  2019-04-15T12:14:03.299896-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.240-2-g7efc75c  
# 	   update production standards 
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
DEFAULT_USER_HOME=$(echo ~ | sed s/${USER}//)
DEFAULT_SSH_USER="${USER}"
### production standard 8.3.204 --usage
display_usage() {
COMMAND_NAME=$(echo $0 | sed 's/^.*\///')
echo -e "\n${NORMAL}${0}\n   Check user RSA ssh file permissions"
echo -e "\nUSAGE"
echo -e "   ${COMMAND_NAME} [-U <USER_HOME>] [-S <SSH_USER>]\n"
echo    "   ${COMMAND_NAME} [--help | -help | help | -h | h | -?]"
echo    "   ${COMMAND_NAME} [--usage | -usage | -u]"
echo    "   ${COMMAND_NAME} [--version | -version | -v]"
}
### production standard 0.1.166 --help
display_help() {
display_usage
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo -e "\nDESCRIPTION"
echo    "This script allows users to make sure that the ssh files and directory"
echo    "permissions are correct.  If they are not correct then this script will correct"
echo    "the permissions.  Administrators can check other users ssh keys by using:"
echo -e "\t${BOLD}sudo ${COMMAND_NAME} <SSH_USER>${NORMAL}"
echo    "To create a new ssh key:"
echo -e "\t${BOLD}ssh-keygen -t rsa -b 4096 -o -C \"\${USER}@\$(hostname -f)_[\$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)_\$(date -d +52weeks +%Y-%m-%dT%H:%M:%S.%6N%:z)]\"${NORMAL}"
echo    "To copy ssh key to a remote system:"
echo -e "\t${BOLD}ssh-copy-id <SSH_USER>@<REMOTE_HOST>${NORMAL}"
echo    "Enter the following command to test if public and private key match:"
echo -e "\t${BOLD}ssh-keygen -y -f ~/.ssh/id_rsa | diff -s - <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)${NORMAL}"
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
echo    "   DEBUG       (default off '0')"
echo    "   USER_HOME   Location of user home directory (default ${DEFAULT_USER_HOME})"
echo    "               Many sites have different home directories (/u/north-office/)"
echo -e "\nOPTIONS"
echo -e "Order of precedence: CLI options, environment variable, default code.\n"
echo    "   -U, --user_home, -U=, --user_home=<USER_HOME>"
echo -e "\tLocation of user home directory (default ${DEFAULT_USER_HOME})\n"
echo    "   -S, --ssh_user, -S=*, --ssh_user=<SSH_USER>"
echo -e "\tUser (default ${DEFAULT_SSH_USER})"
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "└── <USER-1>/.ssh/                         <-- Secure Socket Shell directory"
echo    "    ├── authorized_keys                    <-- SSH keys for logging into account"
echo    "    ├── config                             <-- SSH client configuration file"
echo    "    ├── id_rsa                             <-- SSH private key"
echo    "    ├── id_rsa.pub                         <-- SSH public key"
echo    "    └── known_hosts                        <-- Systems previously connected to"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/docker-security-infrastructure/tree/master/ssh"
echo -e "\nEXAMPLES"
echo -e "   User checks their ssh file permissions\n\t${BOLD}${COMMAND_NAME}${NORMAL}"
echo -e "   User sam checks their ssh file permissions in a non-default home directory\n\t${BOLD}${COMMAND_NAME} sam /u/north-office/${NORMAL}"
echo -e "   Administrator checks user bob ssh file permissions\n\t${BOLD}sudo ${COMMAND_NAME} bob${NORMAL}"
echo -e "   Administrator checks user sally ssh file permissions in a different home\n   directory\n\t${BOLD}sudo ${COMMAND_NAME} sally /u/home-office/${NORMAL}"
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)
TEMP=$(date +%Z)
DATE_STAMP="${DATE_STAMP} (${TEMP})"
}

#       Fully qualified domain name FQDN hostname
LOCALHOST=$(hostname -f)

#       Version
SCRIPT_NAME=$(head -2 "${0}" | awk {'printf $2'})
SCRIPT_VERSION=$(head -2 "${0}" | awk {'printf $3'})

#       UID and GID
USER_ID=$(id -u)
GROUP_ID=$(id -g)

#       Added line because USER is not defined in crobtab jobs
if ! [ "${USER}" == "${LOGNAME}" ] ; then  USER=${LOGNAME} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Setting USER to support crobtab...  USER >${USER}<  LOGNAME >${LOGNAME}<" 1>&2 ; fi

#       Default help, usage, and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi
if [ "$1" == "--usage" ] || [ "$1" == "-usage" ] || [ "$1" == "usage" ] || [ "$1" == "-u" ] ; then
        display_usage | more
        exit 0
fi

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then USER_HOME=${1} ; elif [ "${USER_HOME}" == "" ] ; then USER_HOME="${DEFAULT_USER_HOME}" ; fi
#       Order of precedence: CLI argument, default code
SSH_USER=${2:-${DEFAULT_SSH_USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  USER_HOME >${USER_HOME}< SSH_USER >${SSH_USER}<" 1>&2 ; fi

#	Root is required to check other users or user can check their own certs
if ! [ "${USER_ID}" = 0 -o "${USER}" = "${SSH_USER}" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Use sudo ${0}  ${SSH_USER} to check other users certs" 1>&2
#       Help hint
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}" 1>&2
	exit 1
fi

echo -e "\n\t${NORMAL}Verify and correct file and directory permissions for ${USER_HOME}/${SSH_USER}/.ssh"
###
#	Check if user has home directory on system
if [ ! -d "${USER_HOME}"/"${SSH_USER}" ] ; then 
#       Help hint
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   ${SSH_USER} does not have a home directory on this system or ${SSH_USER} home directory is not ${USER_HOME}/${SSH_USER}" 1>&2
	exit 1
fi

#	Check if ${USER_HOME}/${SSH_USER} directory is owned by ${SSH_USER}
if [ $(stat -Lc %U "${USER_HOME}/${SSH_USER}") != ${SSH_USER} ]; then
#       Help hint
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSH_USER} does not own ${USER_HOME}/${SSH_USER} directory" 1>&2
	exit 1
fi

#	Check ${USER_HOME}/${SSH_USER} directory permissions
#	https://unix.stackexchange.com/questions/37164/ssh-and-home-directory-permissions
if ! [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}") == 755 ] || [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}") == 750 ] || [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}") == 700 ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${USER_HOME}/${SSH_USER} are not 755 or 750 or 700.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}) to only the directory owner with write permissions" 1>&2
	chmod go-w "${USER_HOME}"/"${SSH_USER}"
fi

###
#	Check if .ssh directory exists
if [ ! -d "${USER_HOME}"/"${SSH_USER}"/.ssh ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSH_USER} does not have a .ssh directory" 1>&2
#       Help hint
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa -b 4096 -o -C \"${USER}@$(hostname -f)_[$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)_$(date -d +52weeks +%Y-%m-%dT%H:%M:%S.%6N%:z)]\"${NORMAL}\n"
	exit 1
fi

#	Check if .ssh directory is owned by ${SSH_USER}
if [ $(stat -Lc %U "${USER_HOME}/${SSH_USER}/.ssh") != ${SSH_USER} ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory owner for ${USER_HOME}/${SSH_USER}/.ssh is not owned by ${SSH_USER}.  Correcting $(stat -Lc %U ${USER_HOME}/${SSH_USER}/.ssh) to ${SSH_USER}" 1>&2
	chown -R ${SSH_USER} "${USER_HOME}"/"${SSH_USER}"/.ssh
fi

#	Check ${USER_HOME}/${SSH_USER}/.ssh directory permissions
if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh") != 700 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${USER_HOME}/${SSH_USER}/.ssh are not 700.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh) to 0700 directory permissions" 1>&2
	chmod 0700 "${USER_HOME}"/"${SSH_USER}"/.ssh
fi

###
#	Check if user has ${USER_HOME}/${SSH_USER}/.ssh/id_rsa file
if [ ! -e "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSH_USER} does not have a .ssh/id_rsa file" 1>&2
#       Help hint
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa -b 4096 -o -C \"${USER}@$(hostname -f)_[$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)_$(date -d +52weeks +%Y-%m-%dT%H:%M:%S.%6N%:z)]\"${NORMAL}\n"
	exit 1
fi

#	Verify and correct file permissions for ${USER_HOME}/${SSH_USER}/.ssh/id_rsa
if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh/id_rsa") != 600 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}/${SSH_USER}/.ssh/id_rsa are not 600.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh/id_rsa) to 0600 file permissions" 1>&2
	chmod 0600 "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa
fi

###
#	Check if user has ${USER_HOME}/${SSH_USER}/.ssh/id_rsa.pub file
if [ ! -e "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa.pub ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSH_USER} does not have a .ssh/id_rsa.pub file" 1>&2
#       Help hint
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa -b 4096 -o -C \"${USER}@$(hostname -f)_[$(date +%Y-%m-%dT%H:%M:%S.%6N%:z)_$(date -d +52weeks +%Y-%m-%dT%H:%M:%S.%6N%:z)]\"${NORMAL}\n"
	exit 1
fi

#	Verify and correct file permissions for ${USER_HOME}/${SSH_USER}/.ssh/id_rsa.pub
if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh/id_rsa.pub") != 644 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}/${SSH_USER}/.ssh/id_rsa.pub are not 644.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh/id_rsa.pub) to 0644 file permissions" 1>&2
	chmod 0644 "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa.pub
fi

#	Check if user has .ssh/config file
if [ -e "${USER_HOME}"/"${SSH_USER}"/.ssh/config ] ; then 
#	Verify and correct file permissions for ${USER_HOME}/${SSH_USER}/.ssh/config
	if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh/config") != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}/${SSH_USER}/.ssh/config are not 600.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh/config) to 600 file permissions" 1>&2
		chmod 600 "${USER_HOME}"/"${SSH_USER}"/.ssh/config
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/config file.  For more information enter:  ${BOLD}man ssh_config${NORMAL}" 1>&2
fi

#	Check if user has .ssh/known_hosts file
if [ -e "${USER_HOME}"/"${SSH_USER}"/.ssh/known_hosts ] ; then 
#	Verify and correct file permissions for ${USER_HOME}/${SSH_USER}/.ssh/known_hosts
	if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh/known_hosts") != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}/${SSH_USER}/.ssh/known_hosts are not 600.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh/known_hosts) to 600 file permissions" 1>&2
		chmod 600 "${USER_HOME}"/"${SSH_USER}"/.ssh/known_hosts
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/known_hosts file." 1>&2
fi

#	Use case:
#	   If you have an encrypted home directory, SSH cannot access your authorized_keys file
#	   because it is inside your encrypted home directory and won't be available until after
#	   you are authenticated.  Therefore, SSH will default to password authentication 

#	Check if AuthorizedKeysFile in /etc/ssh/sshd_config is defined with additional locations for authorized_keys

### >>> Need to add check for other authorized_keys file location in /etc/ssh/sshd_config file #51
###	grep -v "#" /etc/ssh/sshd_config | grep -i AuthorizedKeysFile
#	directory permission to this location  755 ?
#	file permissions for authorized_keys  644 ?
#	trouble shooting section, need to test
#	https://unix.stackexchange.com/questions/37164/ssh-and-home-directory-permissions


#	Check if user has ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys file
if [ -e "${USER_HOME}"/"${SSH_USER}"/.ssh/authorized_keys ] ; then 
#	Verify and correct file permissions for ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys
	if [ $(stat -Lc %a "${USER_HOME}/${SSH_USER}/.ssh/authorized_keys") != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys are not 600.  Correcting $(stat -Lc %a ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys) to 600 file permissions" 1>&2
		chmod 600 "${USER_HOME}"/"${SSH_USER}"/.ssh/authorized_keys
	fi
#	List of authorized hosts in ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys
	echo -e "\n\tList of ${BOLD}authorized hosts${NORMAL} in ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys:${BOLD}\n"
	cut -d ' ' -f 3- "${USER_HOME}"/"${SSH_USER}"/.ssh/authorized_keys | sort
	echo -e "\n\t${NORMAL}To remove a host from ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys file:\n\n\t${BOLD}REMOVE_HOST='<user_name>@<host_name>'\n\tgrep -v \$REMOVE_HOST ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys > ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys.new\n\tmv ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys.new ${USER_HOME}/${SSH_USER}/.ssh/authorized_keys${NORMAL}"
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/authorized_keys file." 1>&2
fi

#	Check if user owns .ssh files
echo -e "\n\tCheck if all files in ${USER_HOME}/${SSH_USER}/.ssh directory are owned\n\tby ${SSH_USER}.  If files are not owned by ${SSH_USER} then list them below:${BOLD}" 1>&2
find "${USER_HOME}"/"${SSH_USER}"/.ssh ! -user "${SSH_USER}" -exec ls -l {} \;
echo   "${NORMAL}"
chown -R ${SSH_USER} "${USER_HOME}"/"${SSH_USER}"/.ssh

#	Check if user private key and user public key are a matched set
if ! [ "$(id -u)" = 0 ] ; then
	echo -e "\n\tCheck if ${SSH_USER} private key and public key are a\n\tmatched set (identical) or not a matched set (differ):\n"
	ssh-keygen -y -f "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa | diff -s - <(cut -d ' ' -f 1,2 "${USER_HOME}"/"${SSH_USER}"/.ssh/id_rsa.pub)
else
	echo -e "\n\tRoot is unable to check if ${SSH_USER} private key and public key are a\n\tmatched set (identical) or not a matched set (differ).  Only a user will be\n\table to check if their keys are a matched set or not matched set.\n"
fi

# >>>		May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>		open ticket and remove this comment
#	1/23/2019  it is getting closer just need to test use cases to be finished

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
