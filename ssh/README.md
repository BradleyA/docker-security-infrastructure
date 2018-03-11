## ssh

Check user RSA ssh file permissions

This script allows users to make sure that the ssh files and directory permissions are correct and corrected if not correct.  Administrators can check other users ssh keys by using: sudo /usr/local/bin/check-user-ssh.sh <SSH-USER>.  Currently not supporting id_dsa.pub.

    drwx------  2 uadmin uadmin 4096 Mar  5 13:55 .
    drwxr-xr-x 15 uadmin uadmin 4096 Mar 10 19:22 ..
    -rw-------  1 uadmin uadmin 3563 Feb 22 12:27 authorized_keys
    -rw-------  1 uadmin uadmin 1675 Oct  7 20:37 id_rsa
    -rw-r--r--  1 uadmin uadmin  398 Oct  7 20:37 id_rsa.pub
    -rw-r--r--  1 uadmin uadmin 5324 Mar  1 14:38 known_hosts

To create a new ssh key; ssh-keygen -t rsa
Users can enter the following command to test if public and private key match:
diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)

Repeat the SSH login with the -vvv for verbose mode to help resolve this incident.
ssh -vvv uthree@192.168.1.203

### Clone
To install, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts/ssh

### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

### License::
Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
