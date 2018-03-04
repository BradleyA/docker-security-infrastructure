#!/bin/bash
# 	check-user-ssh.sh  3.16.322  2018-03-04_13:24:51_CST  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.15-3-gd1f73f0  
# 	   initial commit for check-user-ssh.sh 
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Check user ssh permissions"
echo -e "\nUSAGE\n   ${0} <user-name> <home-directoty>"
echo    "	>>> UNDER DEVELOPMENT <<<  "
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nUsers can check file persmiiions  XXXXxxxXXXXX     or other"
echo    "non-default home directories.  The file and directory permissions are also"
echo    "checked.  Administrators can check other users certificates by using"
echo    "sudo ${0} <TLS-user>."
echo -e "\nOPTIONS"
echo    "   TLSUSER   user, default is user running script"
echo    "   USERHOME  location of user home directory, default /home/"
echo    "      Many sites have different home directories locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/docker-TLS"
echo -e "\nEXAMPLES\n   User sam can check their certificates\n\t${0}"
echo -e "   User sam checks their certificates in a non-default home directory\n\t${0} sam /u/north-office/"
echo -e "   Administrator checks user bob certificates\n\tsudo ${0} bob"
echo -e "   Administrator checks user sam certificates in a different home directory\n\tsudo ${0} sam /u/north-office/"
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
TLSUSER=${1:-${USER}}
USERHOME=${2:-/home/}
LOCALHOSTNAME=`hostname -f`
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${TLSUSER} ] ; then
	display_help
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Use sudo ${0}  ${TLSUSER}"	1>&2
	echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${TLSUSER} ] ; then 
	display_help
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${TLSUSER} does not have a home directory\n\ton this system or ${TLSUSER} home directory is not ${USERHOME}${TLSUSER}"	1>&2
	exit 1
fi
#	Check if user has .ssh directory
if [ ! -d ${USERHOME}${TLSUSER}/.ssh ] ; then 
	display_help
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${TLSUSER} does not have a .ssh directory"	1>&2
	exit 1
fi
#	Check if user has .ssh id_rsa file
if [ ! -e ${USERHOME}${TLSUSER}/.ssh/id_rsa ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${TLSUSER} does not have a .ssh/id_rsa file"	1>&2
	exit 1
fi
#	Check if user has .ssh id_rsa.pub file
if [ ! -e ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${TLSUSER} does not have a .ssh/id_rsa.pub file"	1>&2
	exit 1
fi
#	Check if a RSA public / private key pair matche
echo -e "\n${NORMAL}Check if ${USERHOME}${TLSUSER}/.ssh/id_rsa matches ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub."
diff -qs <(ssh-keygen -y -f ${USERHOME}${TLSUSER}/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ${USERHOME}${TLSUSER}/ssh/id_rsa.pub)
#	Verify and correct directory permissions for ${USERHOME}${TLSUSER}/.ssh
echo    "Verify and correct directory permissions for ${USERHOME}${TLSUSER}/.ssh"
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh) != 700 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Directory permissions for ${USERHOME}${TLSUSER}/.ssh\n\tare not 700.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh) to 0700 directory permissions"	1>&2
	chmod 0700 ${USERHOME}${TLSUSER}/.ssh
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.ssh/id_rsa
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/id_rsa) != 600 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${TLSUSER}/.ssh/id_rsa\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/id_rsa) to 0600 file permissions"	1>&2
	chmod 0600 ${USERHOME}${TLSUSER}/.shh/id_rsa
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub) != 644 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub\n\tare not 644.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub) to 0644 file permissions"	1>&2
	chmod 0644 ${USERHOME}${TLSUSER}/.ssh/id_rsa.pub
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.ssh/authorized_keys
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/authorized_keys) != 600 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${TLSUSER}/.ssh/authorized_keys\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/authorized_keys) to 600 file permissions"	1>&2
	chmod 700 ${USERHOME}${TLSUSER}/.ssh/authorized_keys
fi
#	Verify and correct file permissions for ${USERHOME}${TLSUSER}/.ssh/known_hosts
if [ $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/known_hosts) != 644 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${TLSUSER}/.ssh/known_hosts\n\tare not 644.  Correcting $(stat -Lc %a ${USERHOME}${TLSUSER}/.ssh/known_hosts) to 644 file permissions"	1>&2
	chmod 700 ${USERHOME}${TLSUSER}/.ssh/known_hosts
fi
echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
#
#	May want to create a version of this script that automates this process for SRE tools,
#		but keep this script for users to run manually,
#	open ticket and remove this comment
###
