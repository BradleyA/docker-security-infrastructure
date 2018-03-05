#!/bin/bash
# 	check-user-ssh.sh  3.18.324  2018-03-05_11:29:32_CST  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.17  
# 	   cleanup display_help, changed TLSUSER to SSHUSER, debug 
# 	check-user-ssh.sh  3.17.323  2018-03-04_13:42:20_CST  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.16  
# 	   completed debug process, ready for production 
# 	check-user-ssh.sh  3.16.322  2018-03-04_13:24:51_CST  https://github.com/BradleyA/docker-scripts  uadmin  six-rpi3b.cptx86.com 3.15-3-gd1f73f0  
# 	   initial commit for check-user-ssh.sh 
#
#	set -x
#	set -v
#
display_help() {
echo -e "\n${0} - Check user ssh file permissions"
echo -e "\nUSAGE\n   ${0} <user-name> <home-directoty>"
echo    "   ${0} [--help | -help | help | -h | h | -? | ?] [--version | -v]"
echo -e "\nDESCRIPTION\nUsers can make sure that the piblic and private keys match.  The file and"
echo    "directory permissions are also checked.  Administrators can check other users"
echo    "ssh keys by using: sudo ${0} <SSH-user>."
echo -e "\nOPTIONS"
echo    "   SSHUSER   user, default is user running script"
echo    "   USERHOME  location of user home directory, default /home/"
echo    "      Many sites have different home directories locations (/u/north-office/)"
echo -e "\nDOCUMENTATION\n   https://github.com/BradleyA/docker-scripts/tree/master/ssh"
echo -e "\nEXAMPLES\n   User sam can check their ssh\n\t${0}"
echo -e "   User sam checks their ssh in a non-default home directory\n\t${0} sam /u/north-office/"
echo -e "   Administrator checks user bob ssh\n\tsudo ${0} bob"
echo -e "   Administrator checks user sam ssh in a different home directory\n\tsudo ${0} sam /u/north-office/"
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
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
#	Root is required to check other users or user can check their own certs
if ! [ $(id -u) = 0 -o ${USER} = ${SSHUSER} ] ; then
	echo "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Use sudo ${0}  ${SSHUSER}"	1>&2
	echo -e "${BOLD}\n>>   SCRIPT MUST BE RUN AS ROOT TO CHECK <another-user>/.ssh DIRECTORY. <<\n${NORMAL}"	1>&2
	exit 1
fi
#	Check if user has home directory on system
if [ ! -d ${USERHOME}${SSHUSER} ] ; then 
	echo -e "${NORMAL}${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a home directory\n\ton this system or ${SSHUSER} home directory is not ${USERHOME}${SSHUSER}"	1>&2
	exit 1
fi
#	Check if user has .ssh directory
if [ ! -d ${USERHOME}${SSHUSER}/.ssh ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh directory"	1>&2
	exit 1
fi
#	Check if user has .ssh id_rsa file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh/id_rsa file"	1>&2
	exit 1
fi
#	Check if user has .ssh id_rsa.pub file
if [ ! -e ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub ] ; then 
	echo -e "${NORMAL}\n${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  ${SSHUSER} does not have a .ssh/id_rsa.pub file"	1>&2
	exit 1
fi
#	Check if a SSH public / private key pair matche
echo -e "\n${NORMAL}Check if ${USERHOME}${SSHUSER}/.ssh/id_rsa matches ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub."
diff -qs <(ssh-keygen -y -f ${USERHOME}${SSHUSER}/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub)
#	Verify and correct directory permissions for ${USERHOME}${SSHUSER}/.ssh
echo    "Verify and correct file and directory permissions for ${USERHOME}${SSHUSER}/.ssh"
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) != 700 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  Directory permissions for ${USERHOME}${SSHUSER}/.ssh\n\tare not 700.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh) to 0700 directory permissions"	1>&2
	chmod 0700 ${USERHOME}${SSHUSER}/.ssh
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) != 600 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa) to 0600 file permissions"	1>&2
	chmod 0600 ${USERHOME}${SSHUSER}/.ssh/id_rsa
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) != 644 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub\n\tare not 644.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub) to 0644 file permissions"	1>&2
	chmod 0644 ${USERHOME}${SSHUSER}/.ssh/id_rsa.pub
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) != 644 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/known_hosts\n\tare not 644.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/known_hosts) to 644 file permissions"	1>&2
	chmod 644 ${USERHOME}${SSHUSER}/.ssh/known_hosts
fi
#	Verify and correct file permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys
if [ $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) != 600 ]; then
	echo -e "${0} ${LINENO} [${BOLD}ERROR${NORMAL}]:  File permissions for ${USERHOME}${SSHUSER}/.ssh/authorized_keys\n\tare not 600.  Correcting $(stat -Lc %a ${USERHOME}${SSHUSER}/.ssh/authorized_keys) to 600 file permissions"	1>&2
	chmod 600 ${USERHOME}${SSHUSER}/.ssh/authorized_keys
fi
#	List of authorized hosts in ${USERHOME}${SSHUSER}/.ssh/authorized_keys
echo    "List of authorized hosts in ${USERHOME}${SSHUSER}/.ssh/authorized_keys:"
cut -d ' ' -f 3 ${USERHOME}${SSHUSER}/.ssh/authorized_keys | sort
echo -e "To remove a host for ${USERHOME}${SSHUSER}/.ssh/authorized_keys file:\n\tREMOVE_HOST='<host_name>' ; grep -v \$REMOVE_HOST /home/uadmin/.ssh/authorized_keys > /home/uadmin/.ssh/authorized_keys.new ; mv /home/uadmin/.ssh/authorized_keys.new /home/uadmin/.ssh/authorized_keys"
#
echo -e "\n${0} ${LINENO} [${BOLD}INFO${NORMAL}]:	Done.\n"	1>&2
#
#	May want to create a version of this script that automates this process for SRE tools,
#		but keep this script for users to run manually,
#	open ticket and remove this comment
###
