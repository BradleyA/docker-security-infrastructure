#!/bin/bash
# 	ssh/check-host-fingerprint.sh  3.253.718  2019-06-07T20:41:42.369425-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.252  
# 	   ssh/check-host-fingerprint.sh first ruff idea 

#	rm ssh_host_rsa_key*
#	ssh-keygen -t rsa -b 4096 -C "[$(date +%Y-%m-%dT%H:%M:%S.%6N%:z) - $(date -d '+52 weeks' +%Y-%m-%dT%H:%M:%S.%6N%:z) $(hostname -f)]" -V +52w1d -f ssh_host_rsa_key -N ""  > ssh_host_rsa_fingerprint
#	
#	rm ssh_host_ed25519_key*
#	ssh-keygen -t ed25519 -C "[$(date +%Y-%m-%dT%H:%M:%S.%6N%:z) - $(date -d '+52 weeks' +%Y-%m-%dT%H:%M:%S.%6N%:z) $(hostname -f)]" -V +52w1d -f ssh_host_ed25519_key -N "" > ssh_host_ed25519_fingerprint



ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key.pub
ssh-keygen -l -f /etc/ssh/ssh_host_ed25519_key.pub

