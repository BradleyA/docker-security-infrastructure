#!/bin/bash
# 	ssh/check-user-ssh.sh  3.74.431  2018-10-22T21:18:56.500555-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.73  
# 	   Need to retest everything after all the formating changes #30 
# 	ssh/check-user-ssh.sh  3.63.420  2018-10-22T10:27:30.953228-05:00 (CDT)  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.62  
# 	   check-host-tls.sh Change echo or print DEBUG INFO WARNING ERROR close #19 
#
###	check-user-ssh.sh - Check user RSA ssh file permissions
DEBUG=0                 # 0 = debug off, 1 = debug on
#	set -x
#	set -v
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Check user RSA ssh file permissions"
echo -e "\nUSAGE\n   ${0} [<user-name> <home-directoty>]"
echo    "   ${0} [--help | -help | help | -h | h | -?]"
echo    "   ${0} [--version | -version | -v]"
echo -e "\nDESCRIPTION\nThis script allows users to make sure that the ssh files and directory"
echo    "permissions are correct.  If they are not correct then this script will"
echo    "correct the permissions.  Administrators can check other users ssh keys by"
echo    "using: sudo ${0} <SSH-USER>."
echo -e "\nTo create a new ssh key:\n\n   ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
echo    "Enter the following command to test if public and private key match:"
echo -e "\n   ${BOLD}diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)${NORMAL}"
echo -e "\nOPTIONS"
echo    "   SSHUSER   user, default is user running script"
echo    "   USERHOME  location of user home directory, default /home/"
echo    "      Many sites have different home directories locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/ssh"
echo -e "\nEXAMPLES\n   User checks their ssh file permissions\n\n   ${0}"
echo -e "\n   User sam checks their ssh file permissions in a non-default home directory\n\n   ${0} sam /u/north-office/"
echo -e "\n   Administrator checks user bob ssh file permissions\n\n   sudo ${0} bob"
echo -e "\n   Administrator checks user sally ssh file permissions in a different home\n   directory\n\n   sudo ${0} sally /u/home-office/\n"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported, Would you like to help translate?" 1>&2
#       elif [ "${LANG}" == "fr_CA.UTF-8" ] ; then
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Display help in ${LANG}" 1>&2
#       else
#               get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[WARN]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Your language, ${LANG}, is not supported.\tWould you like to translate?" 1>&2
fi
}

#       Date and time function ISO 8601
get_date_stamp() {
DATE_STAMP=`date +%Y-%m-%dT%H:%M:%S.%6N%:z`
TEMP=`date +%Z`
DATE_STAMP=`echo "${DATE_STAMP} (${TEMP})"`
}

#  Fully qualified domain name FQDN hostname
LOCALHOST=`hostname -f`

#  Version
SCRIPT_NAME=`head -2 ${0} | awk {'printf$2'}`
SCRIPT_VERSION=`head -2 ${0} | awk {'printf$3'}`

#       UID and GID
USER_ID=`id -u`
GROUP_ID=`id -g`

#       Default help and version arguments
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] ; then
        display_help
        exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-version" ] || [ "$1" == "version" ] || [ "$1" == "-v" ] ; then
        echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
        exit 0
fi

#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Begin" 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Name_of_command >${0}< Name_of_arg1 >${1}<" 1>&2 ; fi

###
SSHUSER=${1:-${USER}}
USERHOME=${2:-/home/}
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[DEBUG]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  SSHUSER >${SSHUSER}< USERHOME >${USERHOME}<" 1>&2 ; fi

#	Root is required to check other users or user can check their own certs
if ! [ ${USER_ID} = 0 -o ${USER} = ${SSHUSER} ] ; then
#	if ! [ $(id -u) = 0 -o ${USER} = ${SSHUSER} ] ; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Use sudo ${0}  ${SSHUSER}" 1>&2
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi

#	Check if user has home directory on system
if [ ! -d ${USERHOME}${SSHUSER} ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SSHUSER} does not have a home directory on this system or ${SSHUSER} home directory is not ${USERHOME}${SSHUSER}" 1>&2
	exit 1
fi

#	Check if .ssh directory exists
if [ ! -d ${USERHOME}${SSHUSER}/.ssh ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SSHUSER} does not have a .ssh directory" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#	Check if .ssh directory is owned by ${SSHUSER}
DIRECTORY_OWNER=`ls -ld ${USERHOME}${SSHUSER}/.ssh | awk '{print $3}'`
if [ ! "${SSHUSER}" == "${DIRECTORY_OWNER}" ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SSHUSER} does not own ${USERHOME}${SSHUSER}/.ssh directory" 1>&2
	exit 1
fi

#	Check if user has .ssh/id_rsa file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SSHUSER} does not have a .ssh/id_rsa file" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#	Check if user has .ssh/id_rsa.pub file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub ] ; then 
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  ${SSHUSER} does not have a .ssh/id_rsa.pub file" 1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi

#
echo -e "\n${NORMAL}Verify and correct file and directory permissions for ${USERHOME}${SSHUSER}/.ssh"
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) != 700 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Directory permissions for ${USERHOME}${SSHUSER}/.ssh are not 700.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) to 0700 directory permissions" 1>&2
	chmod 0700 ${USERHOME}${SSHUSER}/.ssh
fi

#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) != 600 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa are not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) to 0600 file permissions" 1>&2
	chmod 0600 ${USERHOME}${SSHUSER}/.ssh/id_rsa
fi

#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) != 644 ]; then
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub are not 644.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) to 0644 file permissions" 1>&2
	chmod 0644 ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
fi

#	Check if user has .ssh/known_hosts file
if [ -e ${USERHOME}${SSHUSER}/.ssh/known_hosts ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  File permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts are not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) to 600 file permissions"      1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/known_hosts
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User does not have a .ssh/known_hosts file."      1>&2
fi

#	Check if user has .ssh/authorized_keys file
if [ -e ${USERHOME}${SSHUSER}/.ssh/authorized_keys ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  File permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys are not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) to 600 file permissions"      1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	fi
#	List of authorized hosts in ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	echo -e "\nList of ${BOLD}authorized hosts${NORMAL} in ${USERHOME}${SSHUSER}/.ssh/authorized_keys:\n${BOLD}"
	cut -d ' ' -f 3 ${USERHOME}${SSHUSER}/.ssh/authorized_keys | sort
	echo -e "\n${NORMAL}To remove a host from ${USERHOME}${SSHUSER}/.ssh/authorized_keys file:\n\n\t${BOLD}REMOVE_HOST='<user_name>@<host_name>'\n\tgrep -v \$REMOVE_HOST ${USERHOME}${SSHUSER}/.ssh/authorized_keys > ${USERHOME}${SSHUSER}/.ssh/authorized_keys.new\n\tmv ${USERHOME}${SSHUSER}/.ssh/authorized_keys.new ${USERHOME}${SSHUSER}/.ssh/authorized_keys${NORMAL}"
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User does not have a .ssh/authorized_keys file."      1>&2
fi

#	Check if user has .ssh/config file
if [ -e ${USERHOME}${SSHUSER}/.ssh/config ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/config
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/config) != 600 ]; then
		get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[ERROR]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  File permissions for ${USERHOME}${SSHUSER}/.ssh/config are not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/config) to 600 file permissions"      1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/config
	fi
else
	get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  User does not have a .ssh/config file.  For more information enter:  ${BOLD}man ssh_config${NORMAL}"      1>&2
fi

#	Check if user owns .ssh files
echo -e "\nCheck if all files in ${USERHOME}${SSHUSER}/.ssh directory are owned\nby ${SSHUSER}.  If files are not owned by ${SSHUSER} then list them below:\n${BOLD}"        1>&2
find ${USERHOME}${SSHUSER}/.ssh ! -user ${SSHUSER} -exec ls -l {} \;
echo   "${NORMAL}"

#	Check if user private key and user public key are a matched set
if ! [ $(id -u) = 0 ] ; then
	echo -e "Check if ${SSHUSER} private key and public key are a\nmatched set (identical) or not a matched set (differ):\n"
	diff -qs <(ssh-keygen -y -f ${USERHOME}${SSHUSER}/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub)
else
	echo -e "Root is unable to check if ${SSHUSER} private key and public key are a\nmatched set (identical) or not a matched set (differ).  Only a user will be\nable to check if their keys are a matched set or not matched set."
fi
#
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${0} ${SCRIPT_VERSION} ${LINENO} ${BOLD}[INFO]${NORMAL}  ${LOCALHOST}  ${USER}  ${USER_ID} ${GROUP_ID}  Done." 1>&2
###
# >>>	#??
# >>>		May want to create a version of this script that automates this process for SRE tools,
# >>>		but keep this script for users to run manually,
# >>>		open ticket and remove this comment
###
