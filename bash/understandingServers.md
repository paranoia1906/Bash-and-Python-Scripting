**Basic**
Files/Directories
1: make a directory
- mkdir <dirname>
2: delete a directory
- rm -rf <dirname> (remember CWD | recursive force)
3: move into a directory, and back out.
- cd <dirname> + cd <.. up a level | ~ users home dir)
4: rename a directory
- cp -a <dirname> /parent/child/<newDirName>  (-a archive) | (-pr preserver file attributes, recursive copy)
5: copy a directory (and all of its contents)
- cp -pr ./<dirname>/ /parent/child/<newDirName>
7: list files in a directory
- ls 
8: list all files, in "long" or "list" format using human readable sizes 
- ls -la (list, all files)

Users
1: create a user
- useradd <username>    |   https://www.centos.org/docs/5/html/5.1/Deployment_Guide/s2-users-add.html
2: change that users password (or set it since it probably does not yet exist)
- passwd <username>
3: find a users user id 
- awk -F':' '{ print $1 }' /etc/passwd/   OR cat /etc/passwd/

Accessing internet resources
1: download a file via http (into current directory)
- curl -o /tmp/<filename.ext> 'https://en-ca.wordpress.org/wordpress-4.9.5-en_CA.zip'
2: download a file using ftp (into current directory)
- ftp domain.com
- username + password
- ftp> ls
- ftp> cd directory
- lcd /home/user/yourdirectoryname (If you dont specify the download directory, the file will be downloaded to the current directory where you were at the time you started the FTP session.)
- lpwd			#print working directory on local host
- get file | mget *.xls
- put /path/file | mput *.xls
- quit
3: download a file using sftp (into current directory)
- sftp <user>@<host or ip>
- get -r <dirname>
4: download a file via Rsync or SCP (into current directory) https://www.tecmint.com/rsync-local-remote-file-synchronization-commands/
- rsync -avzh root@192.168.0.100:/home/tarunika/rpmpkgs /tmp/myrpms   (archive mode, increase verbosity, compress during transfer, human readable)
- rsync -avzhe ssh root@192.168.0.100:/root/install.log /tmp/ (-e command | We will be using “ssh” with “-e” option)
5: curl a page (so you can see what it says!) https://curl.haxx.se/docs/httpscripting.html#GET
- curl <https://url to curl.tld>

File/Directory ownership and permissions
1: change the owner of a file to someone else
-chown <user> <filename>
2: change the group of a file to another group
-chown :<group> <filename>
3: change the owner and group of a file at the same time (https://www.thegeekstuff.com/2012/06/chown-examples)
- chown <user>:<group> <file>
4: change the perms of a file (readme.txt ??) to 755 
- chmod 754 <file>
    4 stands for "read",
    2 stands for "write",
    1 stands for "execute", and
    0 stands for "no permission."

**Advanced**
Services and installing packages
1: install or verify that apache (httpd) is installed
- service httpd status
2: see if apache is started (if so, stop it)
- service httpd status + apachectl -k graceful-stop ( service httpd stop )
3: start apache
- service httpd start
4: restart apache
- service httpd restart 
5: restart apache gracefully
- apachectl -k graceful  (https://httpd.apache.org/docs/2.4/stopping.html)
6: add a rule in the hosts file pointing a fake domain/hostname to the IP address of the server
- nano /etc/hosts + <ip> <domain name> <hostname>
7: run an update via yum
- yum update | yum nano update | yum httpd update
8: install nano
- (sudo) yum update | yum install nano
9: check which ports apache is listening on using netstat -pant 
- (Local Address Column) After : is port (State) show LISTEN
- Consider using awk something like (netstat -pant | awk -v OFS='\t ' '{print $6, $4}')

Reading data and output redirection
1: cat a small file
- cat readme.txt
2: head and tail a medium-large file
- head <filename> + tail <filename>
3: do the same but show 20 lines from head and tail instead of the default 10 lines
- head -n 20 <filename> + tail -n 30 <filename>   OR head -20 <filename>
4: less a file
- less <filename> + q to exit
5: grep for specific text in the file
- grep 'matching text' readme.txt
6: grep for specific text in the file and send the output to a file instead of your screen
- grep 'matching text' readme.txt > results.txt
7: show how many lines are in a file 
- wc -l <filename>

Resources and process information (awk examples https://www.gnu.org/software/gawk/manual/html_node/Printf-Examples.html)
1: show system information from top and find load, io and total/free memeory
-  free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
   NR==2 Ordinal Numbers - rows in this case. 2nd row. print f (formatted print) "memory usage: 1st string/2nd stringMB (2 digit floating point) \ new line
    $3,$2,$3*100/$2 " 3rd column, 2nd column, 3rd column times 100 and divided by the value of 2nd column. (order here defines print f string order)
- top | first line shows "top - 18:28:30 up  4:36,  1 user,  load average: 0.00, 0.00, 0.00"
    "three numbers representing the number of processes waiting for the CPU now, an average for the past five minutes, and an average for the past fifteen minutes. These three numbers are the 'load average'"
- top + 1 | "While in top, you will also want to look at ‘wa’ it should be 0.0% almost all the time. Values *consistently* above 1% may indicate that your storage device is too slow to keep up with incoming requests"
2: find the process (or a few processes) that are consuming the majority of system resources (cpu)
- ps aux | sort -nrk 3,3 | head -n 5
    -nrk 3,3 (numaric sort, reverse comparison result giving greater value first, specify positions [column 3, column3]
3: find all processes with a specific word in them using 'ps aux' and something else
- ps aux | grep 'phrase'  OR (how do I use ps aux -C command-name --no-headers?)
4: count how many of these processes are running (using a command) 
- ps aux --no-headers | wc -l

5 Bonus: What is the avail disk space.
- df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}'
    '$NF=="/" (Only print lines where last column has '/')
    {printf "Disk Usage: %d/%dGB (%s)\n", $3,$2,$5}  =  Disk Usage: digit/digitGB (string)\new-line, '1st digit, 2nd digit, 3rd string'
- df -h | awk '$0 ~ /\// {printf "Disk Usage: %d/%dGB (%s) On Dir: %s \n", $3,$2,$5,$6}'
    Search whole line for / char. If it has the / print the line and gather the speicfic columns that we want. 



** Xtra Advanced But Useful **

1: check iptables rules
- sudo iptables -S (by specification) + sudo iptables -L --line-numbers (table format sorted by chain + line numbers)
2: add an allow rule in the INPUT chain for an IP (use our support IP)
- iptables -A INPUT -p tcp -s XXX.XXX.XXX.XXX -j ACCEPT    (-A Append, -p Protocol, -s Source, -j JumpTarget)
- iptables -A OUTPUT -p tcp -d  XXX.XXX.XXX.XXX -j ACCEPT   (-d Destination)
3: remove a specific rule
- iptables -D <chain> <line num>
4: add a deny rule in the INPUT chain for an IP (block some random country, or some internet troll)
- iptables -A INPUT -p tcp -s XXX.XXX.XXX.XXX -j drop 
5: create a cron job by hand. Make it do something fun like output the current time to a text file once an hour.
- crontab -3
- 10 * * * 0-7 "date > /tmp/cronslog.txt";
6: install memcached (a system service) and edit its config. Give it a decent amount of ram to work with (128 mb).
- yum install memcached
- nano /etc/sysconfig/memcached
7: set memcached to auto start on boot (in runlevels 2-5 only) - verify it is running using netstat -pant
- chkconfig --level 25 memcached on
- netstat -pant
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name
    tcp        0      0 0.0.0.0:11211               0.0.0.0:*                   LISTEN      1332/memcached

