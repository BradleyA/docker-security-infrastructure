#!/bin/bash
# 	ssh/check-host-ssh.sh  3.251.715  2019-06-02T13:56:12.378295-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.250  
# 	   ready to begin debug 
# 	ssh/check-hosts-ssh.sh  3.246.703  2019-05-15T23:15:15.068587-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.245  
# 	   first draft NOT ready for test 
# 	ssh/check-hosts-ssh.sh  3.246.703  2019-05-15T23:14:06.597644-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.245  
# 	   first draft NOT ready for test 
# 	ssh/check-hosts-ssh.sh  3.246.703  2019-05-15T23:12:15.547533-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure.git  uadmin  six-rpi3b.cptx86.com 3.245  
# 	   first draft NOT ready for test 
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"
echo -e ">>>>   >>>>   IN DEVELOPMENT   IN DEVELOPMENT   IN DEVELOPMENT   <<<<   <<<<"
echo -e ">>>>   >>>>               NOT READY FOR PRODUCTION               <<<<   <<<<"
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
DEFAULT_CLUSTER="us-tx-cluster-1/"
DEFAULT_DATA_DIR="/usr/local/data/"
DEFAULT_KEY_LOCATION="%h/.ssh/authorized_keys"
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
echo    "If that does not resolve the prompting challenge then review the man pages for"
echo    "ssh-agent and ssh-add before entering the following in a terminal window."
echo -e "\t${BOLD}eval \$(ssh-agent)${NORMAL}"
echo -e "\t${BOLD}ssh-add${NORMAL}"

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
### production standard 6.1.177 Architecture tree
echo -e "\nARCHITECTURE TREE"   # STORAGE & CERTIFICATION
echo    "/usr/local/data/                           <-- <DATA_DIR>"
echo    "├── <CLUSTER>/                             <-- <CLUSTER>"
echo    "│   ├── SYSTEMS                            <-- List of hosts in cluster"
echo    "│   ├── log/                               <-- Host log directory"
echo    "│   ├── logrotate/                         <-- Host logrotate directory"
echo    "│   └── docker-accounts/                   <-- Docker TLS certs"
echo    "│       ├── <HOST-1>/                      <-- Host in cluster"
echo    "│       │   ├── <USER-1>/                  <-- User TLS certs directory"
echo    "│       │   │   ├── ca.pem       FUTURE    <-- User tlscacert"
echo    "│       │   │   ├── cert.pem     FUTURE    <-- User tlscert"
echo    "│       │   │   ├── key.pem      FUTURE    <-- User tlskey"
echo    "│       │   │   ├── trust/                 <-- Backup of Docker Content Trust"
echo    "│       │   │   │                              (DCT) keys"
echo    "│       │   │   └── ssh/        FUTURE     <-- SSH user inventory"
echo    "│       │   │       └── inventory/ FUTURE  <-- SSH user inventory"
echo    "│       │   └── <USER-2>/                  <-- User TLS certs directory"
echo    "│       └── <HOST-2>/                      <-- Host in cluster"
echo    "└── <STANDALONE>/                          <-- <STANDALONE> Architecture tree"
echo    "                                               is the same as <CLUSTER> TREE but"
echo -e "                                               the systems are not in a cluster\n"
echo    "<USER_HOME>/                               <-- Location of user home directory"
echo    "├── <USER-1>/.docker/                      <-- User docker cert directory"
echo    "│   ├── ca.pem                             <-- Symbolic link to user tlscacert"
echo    "│   ├── cert.pem                           <-- Symbolic link to user tlscert"
echo    "│   ├── key.pem                            <-- Symbolic link to user tlskey"
echo    "│   ├── docker-ca/                         <-- Working directory to create certs"
echo    "│   ├── trust/                             <-- Docker Content Trust (DCT)"
echo    "│   │   ├── private/                       <-- Notary Canonical Root Key ID"
echo    "│   │   │                                      (DCT Root Key)"
echo    "│   │   ├── trusted_certificates/          <-- Docker Content Trust (DCT) keys"
echo    "│   │   └── tuf/                           <-- Update Framework (TUF)"
echo    "│   ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "│   │   │                                      to create registory certs"
echo    "│   │   ├── ca.crt                         <-- Daemon registry domain cert"
echo    "│   │   ├── domain.crt                     <-- Registry cert"
echo    "│   │   └── domain.key                     <-- Registry private key"
echo    "│   ├── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "│   │                                          to create registory certs"
echo    "│   └── registry-certs-<REGISTRY_HOST>-<REGISTRY_PORT>/ <-- Working directory"
echo    "│                                              to create registory certs"
echo    "└── <USER-1>/.ssh/                         <-- Secure Socket Shell directory"
echo    "    ├── authorized_keys                    <-- SSH keys for logging into account"
echo    "    ├── config                             <-- SSH user configuration file"
echo    "    ├── id_rsa                             <-- SSH private key"
echo    "    ├── id_rsa.pub                         <-- SSH public key"
echo -e "    └── known_hosts                        <-- Systems previously connected to\n"
echo    "/etc/ "
echo    "├── docker/ "
echo    "│   ├── certs.d/                           <-- Host docker cert directory"
echo    "│   │   ├── daemon/                        <-- Daemon cert directory"
echo    "│   │   │   ├── ca.pem                     <-- Daemon tlscacert"
echo    "│   │   │   ├── cert.pem                   <-- Daemon tlscert"
echo    "│   │   │   └── key.pem                    <-- Daemon tlskey"
echo    "│   │   ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "│   │   │   └── ca.crt                     <-- Daemon registry domain cert"
echo    "│   │   ├── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "│   │   └── <REGISTRY_HOST>:<REGISTRY_PORT>/ < Registry cert directory"
echo    "│   ├── daemon.json                        <-- Daemon configuration file"
echo    "│   ├── key.json                           <-- Automatically generated dockerd"
echo    "│   │                                          key for TLS connections to other"
echo    "│   │                                          TLS servers"
echo    "│   ├── 10-override.begin                  <-- docker.service.d default lines"
echo    "│   ├── dockerd-configuration-file         <-- Daemon configuration"
echo    "│   ├── dockerd-configuration-file.service <- runs start-dockerd-with-systemd.sh"
echo    "│   │                                          during boot"
echo    "│   ├── docker.org                         <-- Copy of /etc/default/docker"
echo    "│   ├── README.md"
echo    "│   ├── setup-dockerd.sh                   <-- moves and creates files"
echo    "│   ├── start-dockerd-with-systemd.begin   <-- Beginning default lines"
echo    "│   ├── start-dockerd-with-systemd.end     <-- Ending default lines"
echo    "│   ├── start-dockerd-with-systemd.sh"
echo    "│   └── uninstall-dockerd-scripts.sh       <-- Removes files and scripts"
echo    "├── systemd/system/                        <-- Local systemd configurations"
echo    "│   ├── dockerd-configuration-file.service <-- Runs start-dockerd-with-systemd.sh"
echo    "│   ├── docker.service.d/"
echo    "│   │   └── 10-override.conf               <-- Override configutation file"
echo    "│   └── docker.service.wants/              <-- Dependencies"
echo    "├── default/"
echo    "│   └── docker                             <-- Docker daemon Upstart and"
echo    "│                                              SysVinit configuration file"
echo    "├── ssl/"
echo    "│   └── openssl.cnf                       <-- OpenSSL configuration file"
echo    "├── ssh/"
echo    "│   ├── moduli                             <-- Diffie-Hellman moduli"
echo    "│   ├── shosts.equiv                       <-- host-based authentication"
echo    "│   ├── ssh_config                         <-- OpenSSH systemwide configuration"
echo    "│   │                                          file"
echo    "│   ├── sshd_config                        <-- OpenSSH daemon configuration"
echo    "│   │                                          file"
echo    "│   ├── ssh_host_rsa_key                   <-- OpenSSH host private key"
echo    "│   ├── ssh_host_rsa_key.pub               <-- OpenSSH host public key"
echo    "│   ├── ssh_host_ed25519_key               <-- OpenSSH host private key"
echo    "│   ├── ssh_host_ed25519_key.pub           <-- OpenSSH host public key"
echo    "│   └── ssh_known_hosts                    <-- OpenSSH systemwide list of known"
echo    "│                                              public host keys"
echo -e "└── hosts.equiv                            <-- host-based authentication\n"
echo    "/var/"
echo    "├── lib/docker/                            <-- Root directory of persistent"
echo    "│                                              Docker state files; (images)"
echo    "│                                              changed to symbolic link pointing"
echo    "│                                              to <DATA_DIR>/<CLUSTER>/docker"
echo    "└── run/"
echo    "    ├── docker/                            <-- Root directory for Docker"
echo    "    │                                          execution state files"
echo    "    ├── docker.pid                         <-- Docker daemon PID file"
echo    "    └── docker.######.######/              <-- Root directory for Docker"
echo    "                                               execution state files using"
echo    "                                               user namespace"
echo -e "\nDOCUMENTATION"
echo    "   https://github.com/BradleyA/   <<URL to online repository README>>"
echo -e "\nEXAMPLES"
echo -e "   <<your code examples description goes here>>\n\t${BOLD}${0} <<code example goes here>>${NORMAL}"
echo -e "   <<your code examples description goes here>>\n\t${BOLD}${0}${NORMAL}"
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

### production standard 2.0 log format (WHEN WHERE WHAT Version Line WHO UID:GID [TYPE] Message)
#       INFO
get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  Started..." 1>&2

#       DEBUG
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Name_of_command >${0}< Name_of_arg1 >${1}< Name_of_arg2 >${2}< Name_of_arg3 >${3}<  Version of bash ${BASH_VERSION}" 1>&2 ; fi

###
#       Root is required to copy certs
#	if ! [ $(id -u) = 0 ] ; then
#	        display_help | more
#	        get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[ERROR]${NORMAL}  Use sudo ${0}" 1>&2
#	#       Help hint
#	        echo -e "\n\t${BOLD}>>   SCRIPT MUST BE RUN AS ROOT   <<\n${NORMAL}"    1>&2
#	        exit 1
#	fi
#	
### production standard 7.0 Default variable value
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  1 ]  ; then CLUSTER=${1} ; elif [ "${CLUSTER}" == "" ] ; then CLUSTER=${DEFAULT_CLUSTER} ; fi
#       Order of precedence: CLI argument, environment variable, default code
if [ $# -ge  2 ]  ; then DATA_DIR=${3} ; elif [ "${DATA_DIR}" == "" ] ; then DATA_DIR=${DEFAULT_DATA_DIR} ; fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  Variable... CLUSTER >${CLUSTER}< DATA_DIR >${DATA_DIR}<" 1>&2 ; fi

###
#	     AuthorizedKeysFile
#             Specifies the file that contains the public keys that can be used for user authentication.  The format is described in the AUTHORIZED_KEYS FILE FORMAT section
#             of sshd(8).  AuthorizedKeysFile may contain tokens of the form %T which are substituted during connection setup.  The following tokens are defined: %% is
#             replaced by a literal '%', %h is replaced by the home directory of the user being authenticated, and %u is replaced by the username of that user.  After expan‐
#             sion, AuthorizedKeysFile is taken to be an absolute path or one relative to the user's home directory.  Multiple files may be listed, separated by whitespace.
#             Alternately this option may be set to “none” to skip checking for user keys in files.  The default is “.ssh/authorized_keys .ssh/authorized_keys2”.
###
#	     AuthorizedKeysFile specifies the files containing public keys for public key authentication; if this option is not specified, the default is
#	     ~/.ssh/authorized_keys and ~/.ssh/authorized_keys2.  Each line of the file contains one key (empty lines and lines starting with a ‘#’ are ignored as
#	     comments).  Protocol 1 public keys consist of the following space-separated fields: options, bits, exponent, modulus, comment.  Protocol 2 public key
#	     consist of: options, keytype, base64-encoded key, comment.  The options field is optional; its presence is determined by whether the line starts with a
#	     number or not (the options field never starts with a number).  The bits, exponent, modulus, and comment fields give the RSA key for protocol version 1;
#	     the comment field is not used for anything (but may be convenient for the user to identify the key).  For protocol version 2 the keytype is
#	     “ecdsa-sha2-nistp256”, “ecdsa-sha2-nistp384”, “ecdsa-sha2-nistp521”, “ssh-ed25519”, “ssh-dss” or “ssh-rsa”.
###
#	Multiple locations for openssh's AuthorizedKeysFile useful in combination with encrypted home dirs (ecryptfs)
#	Sun 02 June 2013
#	by Markus A. Kuppe
#
#	When using disk encryption (e.g. ecryptfs) to protect your private home dir data, ssh pubkey authentication breaks as a side effect. 
#	It breaks for obvious reasons though. Your authorized_keys file lives in ~/.ssh/ which is intentionally encrypted when you are not logged in.
#	
#	A trivial change to still allow password less/free logins, is to add a second authorized_keys file location to /etc/ssh/sshd_config.
#	Just add/change AuthorizedKeysFile to point to '%h/.ssh/authorized_keys /etc/ssh/keys/%u/authorized_keys'.
#	This makes ssh first look into ~/.ssh/ and fall back to /etc/ssh/keys/~/ if no valid authorized_keys file can be found (make sure to chown
#	ownership of the latter to the login user).
###
#	authorizedkeysfile /etc/ssh/keys/%u/authorized_keys
#	use the same permissions as /home for /etc/ssh/keys and give the users read access and ownership to their subdirectories.
###

#	if AuthorizedKeysFile in /etc/ssh/sshd_config is set to none (test to determine correct solution)
#
#	 grep AuthorizedKeysFile /etc/ssh/*config*
#		/etc/ssh/sshd_config:#AuthorizedKeysFile	%h/.ssh/authorized_keys

#	%% is replaced by a literal '%',
#	%h is replaced by the home directory of the user being authenticated,
#	%u is replaced by the username of that user
#	
#	Lines starting with ‘#’ and empty lines are interpreted as comments.
#	keywords are case-insensitive
#	grep AuthorizedKeysFile /tmp/foo | grep -v '^#'
#	/tmp/foo test file
#		AuthorizedKeysFile      %h/.ssh/authorized_keys /etc/ssh/keys/%u/authorized_keys
###
#	AuthorizedKeysFile      /etc/ssh/keys/%u/authorized_keys %h/.ssh/authorized_keys
#	authorized_keys2 deprecated since 2001
AUTHORIZED_KEY_FILES=$(grep 'AuthorizedKeysFile' /etc/ssh/sshd_config | grep -v '#' | cut -d ' ' -f 2-)
if [ -z "${AUTHORIZED_KEY_FILES}" ] ; then
	AUTHORIZED_KEY_FILES=${DEFAULT_KEY_LOCATION}
fi
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  AUTHORIZED_KEY_FILES >${AUTHORIZED_KEY_FILES}< DEFAULT_KEY_LOCATION >${DEFAULT_KEY_LOCATION}<" 1>&2 ; fi

USER_ACCOUNTS=$(grep -v -e 'false$' -e 'nologin$' -e 'sync$' /etc/passwd | cut  -d ':' -f 1)
if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  USER_ACCOUNTS >${USER_ACCOUNTS}<" 1>&2 ; fi

for USER_ACCOUNT in ${USER_ACCOUNTS} ; do
#        echo "${AUTHORIZED_KEY_FILES}"
#        $(echo "${AUTHORIZED_KEY_FILES}" | sed 's&%u&${USER_ACCOUNT}&')
        USER_KEY_FILES=$(echo "${AUTHORIZED_KEY_FILES}" | sed 's&%u&'${USER_ACCOUNT}'&')
	USER_HOME=$(eval echo "~${USER_ACCOUNT}")
        USER_KEY_FILES=$(echo "${USER_KEY_FILES}" | sed 's&%h&'${USER_HOME}'&')
	if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  USER_ACCOUNT >${USER_ACCOUNT}< USER_KEY_FILES >${USER_KEY_FILES}< USER_HOME >${USER_HOME}<" 1>&2 ; fi

	mkdir -p /tmp/KEYS/${USER_ACCOUNT}/ssh/${LOCALHOST}

	for USER_KEY_FILE in ${USER_KEY_FILES} ; do
		if [ "${DEBUG}" == "1" ] ; then get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[DEBUG]${NORMAL}  USER_KEY_FILE >${USER_KEY_FILE}<" 1>&2 ; fi
		if [ ! -s "${USER_KEY_FILE}" ] ; then 
			get_date_stamp ; echo -e "${NORMAL}${DATE_STAMP} ${LOCALHOST} ${0}[$$] ${SCRIPT_VERSION} ${LINENO} ${USER} ${USER_ID}:${GROUP_ID} ${BOLD}[INFO]${NORMAL}  ${USER_KEY_FILE} file not found or is empty." 1>&2
		else
			ls -la ${USER_KEY_FILE}
			echo "       XXXX xxxx found file  what what WHAT"
			USER_AUTHORIZED_KEYS=$(grep -v '#' ${USER_KEY_FILE} | cut -d ' ' -f 3)
			touch /tmp/KEYS/${USER_ACCOUNT}/ssh/${LOCALHOST}/${USER_AUTHORIZED_KEYS}
		fi
	done
done
tree /tmp/KEYS/

###
#	Get fingerprint hashes of Base64 keys
#	ssh-keygen -lf <(ssh-keyscan 192.168.1.103 2>/dev/null)
###
#     Arguments to some keywords	can make use of	tokens,	which are expanded at
#     runtime:
#
#	   %%	 A literal `%'.
#	   %D	 The routing domain in which the incoming connection was
#		 received.
#	   %F	 The fingerprint of the	CA key.
#	   %f	 The fingerprint of the	key or certificate.
#	   %h	 The home directory of the user.
#	   %i	 The key ID in the certificate.
#	   %K	 The base64-encoded CA key.
#	   %k	 The base64-encoded key	or certificate for authentication.
#	   %s	 The serial number of the certificate.
#	   %T	 The type of the CA key.
#	   %t	 The key or certificate	type.
#	   %U	 The numeric user ID of	the target user.
#	   %u	 The username.
