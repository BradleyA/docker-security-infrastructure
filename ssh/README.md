## ssh

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!

#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching. 

I need to complete some cleanup before it is shareable and documented . . .

need a script to check a users file permissions
If you are being prompted for a password prompt instead of a passphrase prompt then check your file permissions for;
    ls -ld $HOME/.ssh (700 or drwx------) and 
    ls -l $HOME/.ssh/id_rsa (600 or -rw------). 

-rw------- 1 uadmin uadmin 3563 Feb 22 12:27 authorized_keys
-rw------- 1 uadmin uadmin 1675 Oct  7 20:37 id_rsa
-rw-r--r-- 1 uadmin uadmin  398 Oct  7 20:37 id_rsa.pub
-rw-r--r-- 1 uadmin uadmin 5324 Mar  1 14:38 known_hosts

Repeat the SSH login with the -vvv for verbose mode to help resolve this incident.
ssh -vvv uthree@192.168.1.203

### Clone
To install, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/docker-scripts
    cd docker-scripts/ssh

### System OS script tested
 * Ubuntu 16.04.3 LTS (armv7l)

### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

### License::
Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
