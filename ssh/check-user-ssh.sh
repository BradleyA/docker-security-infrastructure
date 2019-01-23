#!/bin/bash
# 	ssh/check-user-ssh.sh  3.119.490  2019-01-23T15:13:14.127895-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  four-rpi3b.cptx86.com 3.118  
# 	   added DEBUG, update display_help; update 1-5 productions standards 
# 	ssh/check-user-ssh.sh  3.118.489  2019-01-22T23:14:50.344208-06:00 (CST)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.117  
# 	   production standard 4 Internationalizing display-help close #39 
# 	ssh/check-user-ssh.sh  3.74.431  2018-10-22T21:18:56.500555-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.73  
# 	   Need to retest everything after all the formating changes #30 
# 	ssh/check-user-ssh.sh  3.63.420  2018-10-22T10:27:30.953228-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.62  
# 	   check-host-tls.sh Change echo or print DEBUG INFO WARNING ERROR close #19 
#
###	check-user-ssh.sh - Check user RSA ssh file permissions
#       Copyright (c) 2019 Bradley Allen
#       License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
###
#   production standard 5
#       Order of precedence: environment variable, default code
if [ "${DEBUG}" == "" ] ; then DEBUG="0" ; fi   # 0 = debug off, 1 = debug on, 'export DEBUG=1', 'unset DEBUG' to unset environment variable (bash)
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Check user RSA ssh file permissions"
echo -e "\nUSAGE\n   ${0} [<home-directoty>] [<user-name>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION"
#       Displaying help DESCRIPTION in English en_US.UTF-8
echo    "This script allows users to make sure that the ssh files and directory"
echo    "permissions are correct.  If they are not correct then this script will"
echo    "correct the permissions.  Administrators can check other users ssh keys by"
echo    "using: sudo ${0} <SSH-USER>."
echo -e "\nTo create a new ssh key:\n\n   ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
echo    "Enter the following command to test if public and private key match:"
echo -e "\n   ${BOLD}diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)${NORMAL}"
#       Displaying help DESCRIPTION in French fr_CA.UTF-8, fr_FR.UTF-8, fr_CH.UTF-8
if [ "${LANG}" == "fr_CA.UTF-8" ] || [ "${LANG}" == "fr_FR.UTF-8" ] || [ "${LANG}" == "fr_CH.UTF-8" ] ; then
        echo -e "\n--> ${LANG}"
        echo    "<votre aide va ici>" # your help goes here
        echo    "Souhaitez-vous traduire la section description?" # Do you want to translate the description section?
elif ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[WARN]${NORMAL}  Your language, ${LANG}, is not supported.  Would you like to translate the description section?" 1>&2
fi
echo -e "\nEnvironment Variables"
echo    "If using the bash shell, enter; 'export DEBUG=1' on the command line to set"
echo    "the DEBUG environment variable to '1' (0 = debug off, 1 = debug on).  Use the"
echo    "command, 'unset DEBUG' to remove the exported information from the DEBUG"
echo    "environment variable.  You are on your own defining environment variables if"
echo    "you are using other shells."
echo    "   DEBUG     (default '0')"
echo    "   USERHOME  location of user home directory (default /home/)"
echo    "             Many sites have different home directories (/u/north-office/)"
echo -e "\nOPTIONS"
echo    "   USERHOME  location of user home directory (default /home/)"
echo    "             Many sites have different home directories (/u/north-office/)"
echo    "   SSHUSER   user, default is user running script"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/ssh"
echo -e "\nEXAMPLES\n   User checks their ssh file permissions\n\n   ${0}"
echo -e "\n   User sam checks their ssh file permissions in a non-default home directory\n\n   ${0} sam /u/north-office/"
echo -e "\n   Administrator checks user bob ssh file permissions\n\n   sudo ${0} bob"
echo -e "\n   Administrator checks user sally ssh file permissions in a different home\n   directory\n\n   sudo ${0} sally /u/home-office/\n"
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

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help | more
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then USERHOME=${1} ; elif [ "${USERHOME}" == "" ] ; then USERHOME="/home/" ; fi
#       Order of precedence: CLI argument, default code
SSHUSER=${2:-${USER}}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  USERHOME >${USERHOME}< SSHUSER >${SSHUSER}<" 1>&2 ; fi

#	Root is required to check other users or user can check their own certs
if ! [ "${USER_ID}" = 0 -o "${USER}" = "${SSHUSER}" ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   Use sudo ${0}  ${SSHUSER}" 1>&2
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi

#	Check if user has home directory on system
if [ ! -d "${USERHOME}"/"${SSHUSER}" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}   ${SSHUSER} does not have a home directory on this system or ${SSHUSER} home directory is not ${USERHOME}/${SSHUSER}" 1>&2
	exit 1
fi

#	Check if .ssh directory exists
if [ ! -d "${USERHOME}"/"${SSHUSER}"/.ssh ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSHUSER} does not have a .ssh directory" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#	Check if .ssh directory is owned by ${SSHUSER}
DIRECTORY_OWNER=$(ls -ld ${USERHOME}/${SSHUSER}/.ssh | awk '{print $3}')
if [ ! "${SSHUSER}" == "${DIRECTORY_OWNER}" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSHUSER} does not own ${USERHOME}/${SSHUSER}/.ssh directory" 1>&2
	exit 1
fi

#	Check if user has .ssh/id_rsa file
if [ ! -e "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSHUSER} does not have a .ssh/id_rsa file" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#	Check if user has .ssh/id_rsa.pub file
if [ ! -e "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa.pub ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  ${SSHUSER} does not have a .ssh/id_rsa.pub file" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#
echo -e "\n\t${NORMAL}Verify and correct file and directory permissions for ${USERHOME}/${SSHUSER}/.ssh"
if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh)" != 700 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Directory permissions for ${USERHOME}/${SSHUSER}/.ssh are not 700.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh) to 0700 directory permissions" 1>&2
	chmod 0700 "${USERHOME}"/"${SSHUSER}"/.ssh
fi

#	Verify and correct file permissions for ${USERHOME}/${SSHUSER}/.ssh/id_rsa
if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/id_rsa)" != 600 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USERHOME}/${SSHUSER}/.ssh/id_rsa are not 600.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/id_rsa) to 0600 file permissions" 1>&2
	chmod 0600 "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa
fi

#	Verify and correct file permissions for ${USERHOME}/${SSHUSER}/.ssh/id_rsa.pub
if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/id_rsa.pub)" != 644 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USERHOME}/${SSHUSER}/.ssh/id_rsa.pub are not 644.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/id_rsa.pub) to 0644 file permissions" 1>&2
	chmod 0644 "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa.pub
fi

#	Check if user has .ssh/known_hosts file
if [ -e "${USERHOME}"/"${SSHUSER}"/.ssh/known_hosts ] ; then 
#	Verify and correct file permissions for ${USERHOME}/${SSHUSER}/.ssh/known_hosts
	if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/known_hosts)" != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USERHOME}/${SSHUSER}/.ssh/known_hosts are not 600.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/known_hosts) to 600 file permissions"      1>&2
		chmod 600 "${USERHOME}"/"${SSHUSER}"/.ssh/known_hosts
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/known_hosts file."      1>&2
fi

#	Check if user has .ssh/authorized_keys file
if [ -e "${USERHOME}"/"${SSHUSER}"/.ssh/authorized_keys ] ; then 
#	Verify and correct file permissions for ${USERHOME}/${SSHUSER}/.ssh/authorized_keys
	if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/authorized_keys)" != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USERHOME}/${SSHUSER}/.ssh/authorized_keys are not 600.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/authorized_keys) to 600 file permissions"      1>&2
		chmod 600 "${USERHOME}"/"${SSHUSER}"/.ssh/authorized_keys
	fi
#	List of authorized hosts in ${USERHOME}/${SSHUSER}/.ssh/authorized_keys
	echo -e "\n\tList of ${BOLD}authorized hosts${NORMAL} in ${USERHOME}/${SSHUSER}/.ssh/authorized_keys:${BOLD}\n"
	cut -d ' ' -f 3 "${USERHOME}"/"${SSHUSER}"/.ssh/authorized_keys | sort
	echo -e "\n\t${NORMAL}To remove a host from ${USERHOME}/${SSHUSER}/.ssh/authorized_keys file:\n\n\t${BOLD}REMOVE_HOST='<user_name>@<host_name>'\n\tgrep -v \$REMOVE_HOST ${USERHOME}/${SSHUSER}/.ssh/authorized_keys > ${USERHOME}/${SSHUSER}/.ssh/authorized_keys.new\n\tmv ${USERHOME}/${SSHUSER}/.ssh/authorized_keys.new ${USERHOME}/${SSHUSER}/.ssh/authorized_keys${NORMAL}"
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/authorized_keys file."      1>&2
fi

#	Check if user has .ssh/config file
if [ -e "${USERHOME}"/"${SSHUSER}"/.ssh/config ] ; then 
#	Verify and correct file permissions for ${USERHOME}/${SSHUSER}/.ssh/config
	if [ "$(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/config)" != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  File permissions for ${USERHOME}/${SSHUSER}/.ssh/config are not 600.  Correcting $(stat -Lc %a ${USERHOME}/${SSHUSER}/.ssh/config) to 600 file permissions"      1>&2
		chmod 600 "${USERHOME}"/"${SSHUSER}"/.ssh/config
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  User does not have a .ssh/config file.  For more information enter:  ${BOLD}man ssh_config${NORMAL}"      1>&2
fi

#	Check if user owns .ssh files
echo -e "\n\tCheck if all files in ${USERHOME}/${SSHUSER}/.ssh directory are owned\n\tby ${SSHUSER}.  If files are not owned by ${SSHUSER} then list them below:${BOLD}"        1>&2
find "${USERHOME}"/"${SSHUSER}"/.ssh ! -user "${SSHUSER}" -exec ls -l {} \;
echo   "${NORMAL}"

#	Check if user private key and user public key are a matched set
if ! [ "$(id -u)" = 0 ] ; then
	echo -e "\n\tCheck if ${SSHUSER} private key and public key are a\n\tmatched set (identical) or not a matched set (differ):\n"
	diff -qs <(ssh-keygen -y -f "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa) <(cut -d ' ' -f 1,2 "${USERHOME}"/"${SSHUSER}"/.ssh/id_rsa.pub)
else
	echo -e "\n\tRoot is unable to check if ${SSHUSER} private key and public key are a\n\tmatched set (identical) or not a matched set (differ).  Only a user will be\n\table to check if their keys are a matched set or not matched set.\n"
fi

# >>>		May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>		open ticket and remove this comment
#	1/23/2019  it is getting closer just need to test use cases to be finished

#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Operation finished." 1>&2
###
