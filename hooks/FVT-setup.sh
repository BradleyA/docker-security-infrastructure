#!/bin/bash
# 	hooks/FVT-setup.sh  3.247.474  2019-08-11T07:51:53.596729-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.246-2-g0eac612  
# 	   change test case output extension from .out to .test-case-output #26 
# 	hooks/FVT-setup.sh  3.246.471  2019-08-10T20:05:23.559251-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.245-1-g58d7e0e  
# 	   ### production standard 10.0 FVT testing #26 
# 	hooks/FVT-setup.sh  3.244.468  2019-08-10T19:47:00.778853-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.243  
# 	   hooks/FVT-setup.sh hooks/post-commit move rm -f FVT-*.out from hooks/post-commit to hooks/FVT-setup.sh 
# 	hooks/FVT-setup.sh  3.243.467  2019-08-10T19:39:36.382334-05:00 (CDT)  https://github.com/BradleyA/user-files.git  uadmin  one-rpi3b.cptx86.com 3.242  
# 	   hooks/FVT-setup.sh example FVT-setup.sh file to be placed in TEST/<file_name>/ directory with test cases 
###
#	FVT-setup.sh -  This script is optional.  It runs before test cases are run, if FVT-setup.sh is found in TEST/<file_name>/
#
### production standard 3.0 shellcheck
### production standard 5.1.160 Copyright
##       Copyright (c) 2019 Bradley Allen
##       MIT License is in the online DOCUMENTATION, DOCUMENTATION URL defined below.
### production standard 10.0 FVT testing
#       Remove output from previous run of test cases
rm -f FVT-*.test-case-output
#	Create symbolic link for all test case expected output that matches another test case expected output 
#	Expected output from FVT-option-help-001 matches output from FVT-option-help-00[2,3,4,5,6]
ln -fs FVT-option-help-001.expected FVT-option-help-002.expected
ln -fs FVT-option-help-001.expected FVT-option-help-003.expected
ln -fs FVT-option-help-001.expected FVT-option-help-004.expected
ln -fs FVT-option-help-001.expected FVT-option-help-005.expected
ln -fs FVT-option-help-001.expected FVT-option-help-006.expected
#	Expected output from FVT-option-usage-001 matches output from FVT-option-usage-00[2,3]
ln -fs FVT-option-usage-001.expected FVT-option-usage-002.expected
ln -fs FVT-option-usage-001.expected FVT-option-usage-003.expected 
#	Expected output from FVT-option-version-001 matches output from FVT-option-version-00[2,3]
ln -fs FVT-option-version-001.expected FVT-option-version-002.expected
ln -fs FVT-option-version-001.expected FVT-option-version-003.expected
###		
