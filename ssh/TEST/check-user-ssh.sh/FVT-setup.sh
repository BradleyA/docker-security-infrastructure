#!/bin/bash
# 	ssh/TEST/check-user-ssh.sh/FVT-setup.sh  3.432.907  2019-08-11T08:42:18.965356-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.431-3-gc04328b  
# 	   updated formatting in test cases from prototype to production comments 
# 	ssh/TEST/check-user-ssh.sh/FVT-setup.sh  3.406.877  2019-07-27T23:00:02.863283-05:00 (CDT)  https://github.com/BradleyA/docker-security-infrastructure  uadmin  six-rpi3b.cptx86.com 3.405-2-gc5d946c  
# 	   testing .git/hooks/ #57 
#### production standard 3.0 shellcheck
#### production standard 5.1.160 Copyright
##       Copyright (c) 2019 Bradley Allen
##       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 10.0 FVT testing
#       Remove output from previous run of test cases
rm -f FVT-options*.test-case-output
#
ln -fs FVT-option-help-001.expected FVT-option-help-002.expected
ln -fs FVT-option-help-001.expected FVT-option-help-003.expected
ln -fs FVT-option-help-001.expected FVT-option-help-004.expected
ln -fs FVT-option-help-001.expected FVT-option-help-005.expected
ln -fs FVT-option-help-001.expected FVT-option-help-006.expected
#		
ln -fs FVT-option-usage-001.expected FVT-option-usage-002.expected
ln -fs FVT-option-usage-001.expected FVT-option-usage-003.expected 
#
ln -fs FVT-option-version-001.expected FVT-option-version-002.expected
ln -fs FVT-option-version-001.expected FVT-option-version-003.expected
###		
