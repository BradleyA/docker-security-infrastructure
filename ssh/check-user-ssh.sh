#!/bin/bash
# 	check-user-ssh.sh  3.40.381  2018-08-10_11:04:18_CDT  https://github.com/BradleyA/docker-scripts  uadmin  three-rpi3b.cptx86.com 3.39  
# 	   Check if .ssh directory is owned by ${SSHUSER} close #14 
###
#	set -x
#	set -v
###
DEBUG=0                 # 0 = debug off, 1 = debug on
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
###
display_help() {
echo -e "\n${NORMAL}${0} - Check user RSA ssh file permissions"
echo -e "\nUSAGE\n   ${0} <user-name> <home-directoty>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nUsers can make sure that the file and directory permissions are"
echo    "correct and corrected if needed.  Administrators can check other users ssh"
echo    "keys by using: sudo ${0} <SSH-USER>.  Currently not"
echo    "supporting id_dsa.pub."
echo -e "\nTo create a new ssh key; ssh-keygen -t rsa"
echo    "Enter the following command to test if public and private key match:"
echo    "diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)"
echo -e "\nOPTIONS"
echo    "   SSH-USER   user, default is user running script"
echo    "   USER-HOME  location of user home directory, default /home/"
echo    "      Many sites have different home directories locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/ssh"
echo -e "\nEXAMPLES\n   User sam can check their ssh\n\t${0}"
echo -e "   User sam checks their ssh in a non-default home directory\n\t${0} sam /u/north-office/"
echo -e "   Administrator checks user bob ssh\n\tsudo ${0} bob"
echo -e "   Administrator checks user sally ssh in a different home directory\n\tsudo ${0} sally /u/north-office/"
if ! [ "${LANG}" == "en_US.UTF-8" ] ; then
        echo -e "${NORMAL}${0} ${LINENO} [${BOLD}WARNING${NORMAL}]:     Your language, ${LANG}, is not supported.\n\tWould you like to help?\n" 1>&2
fi
}
if [ "$1" == "--help" ] || [ "$1" == "-help" ] || [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "h" ] || [ "$1" == "-?" ] || [ "$1" == "?" ] ; then
	display_help
	exit 0
fi
if [ "$1" == "--version" ] || [ "$1" == "-v" ] || [ "$1" == "version" ] ; then
        head -2 ${0} | awk {'print$2"\t"$3'}
        exit 0
fi
###
SSHUSER=${1:-${USER}}
USERHOME=${2:-/home/}
LOCALHOSTNAME=`hostname -f`
#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${SSHUSER} ] ; then
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Use sudo ${0}  ${SSHUSER}"	1>&2
	echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${SSHUSER} ] ; then 
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a home directory\n\ton this system or ${SSHUSER} home directory is not ${USERHOME}${SSHUSER}"	1>&2
	exit 1
fi
#	Check if .ssh directory exists
if [ ! -d ${USERHOME}${SSHUSER}/.ssh ] ; then 
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh directory"	1>&2
	echo -e "\n\tTo create an ssh key enter: ${BOLD}ssh-keygen -t rsa${NORMAL}\n"
	exit 1
fi
#	Check if .ssh directory is owned by ${SSHUSER}
DIRECTORY_OWNER=`ls -ld ${USERHOME}${SSHUSER}/.ssh | awk '{print $4}'`
if [ ! "${SSHUSER}" == "${DIRECTORY_OWNER}" ] ; then 
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not own ${USERHOME}${SSHUSER}/.ssh directory"	1>&2
	exit 1
fi
#	Check if user has .ssh/id_rsa file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa ] ; then 
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh/id_rsa file"	1>&2
	exit 1
fi
#	Check if user has .ssh/id_rsa.pub file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub ] ; then 
	echo -e "\n${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh/id_rsa.pub file"	1>&2
	exit 1
fi
#
echo -e "\n${NORMAL}Verify and correct file and directory permissions for ${USERHOME}${SSHUSER}/.ssh"
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) != 700 ]; then
	echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Directory permissions for ${USERHOME}${SSHUSER}/.ssh\n\tare not 700.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) to 0700 directory permissions"	1>&2
	chmod 0700 ${USERHOME}${SSHUSER}/.ssh
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) != 600 ]; then
	echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) to 0600 file permissions"	1>&2
	chmod 0600 ${USERHOME}${SSHUSER}/.ssh/id_rsa
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) != 644 ]; then
	echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub\n\tare not 644.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) to 0644 file permissions"	1>&2
	chmod 0644 ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
fi
#	Check if user has .ssh/known_hosts file
if [ -e ${USERHOME}${SSHUSER}/.ssh/known_hosts ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) != 600 ]; then
		echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) to 600 file permissions"	1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/known_hosts
	fi
else
	echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  User does not have a .ssh/known_hosts file."        1>&2
fi
#	Check if user has .ssh/authorized_keys file
if [ -e ${USERHOME}${SSHUSER}/.ssh/authorized_keys ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) != 600 ]; then
		echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) to 600 file permissions"	1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	fi
#	List of authorized hosts in ${USERHOME}${SSHUSER}/.ssh/authorized_keys
	echo -e "\nList of ${BOLD}authorized hosts${NORMAL} in ${USERHOME}${SSHUSER}/.ssh/authorized_keys:\n${BOLD}"
	cut -d ' ' -f 3 ${USERHOME}${SSHUSER}/.ssh/authorized_keys | sort
	echo -e "\n${NORMAL}To remove a host from ${USERHOME}${SSHUSER}/.ssh/authorized_keys file:\n\n\t${BOLD}REMOVE_HOST='<user_name>@<host_name>'\n\tgrep -v \$REMOVE_HOST /home/uadmin/.ssh/authorized_keys > /home/uadmin/.ssh/authorized_keys.new\n\tmv /home/uadmin/.ssh/authorized_keys.new /home/uadmin/.ssh/authorized_keys${NORMAL}"
else
        echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  User does not have a .ssh/authorized_keys file."        1>&2
fi
#	Check if user has .ssh/config file
if [ -e ${USERHOME}${SSHUSER}/.ssh/config ] ; then 
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/config
	if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/config) != 600 ]; then
		echo -e "\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/config\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/config) to 600 file permissions"	1>&2
		chmod 600 ${USERHOME}${SSHUSER}/.ssh/config
	fi
else
        echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  User does not have a .ssh/config file.\nFor more information enter:\n\n\t${BOLD}man ssh_config${NORMAL}"        1>&2
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
echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:  Done.\n"	1>&2
###
#	May want to create a version of this script that automates this process for SRE tools,
#		but keep this script for users to run manually,
#	open ticket and remove this comment
###
