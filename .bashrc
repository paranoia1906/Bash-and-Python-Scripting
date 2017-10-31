# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

#Setting a function called wpconfig. 
#The script will connect to the database using the wp-config.php and will print the site and home URL. 
function wpconfig() (

# Defining important variables.
USER=$(ls -lad | cut -d\  -f3)
GROUP=$(ls -lad | cut -d\  -f4)
DBNAME=$(cat wp-config.php | grep DB_NAME | cut -d\' -f4)
DBUSER=$(cat wp-config.php | grep DB_USER | cut -d\' -f4)
DBPASSWORD=$(cat wp-config.php | grep DB_PASSWORD | cut -d\' -f4)
DBHOST=$(cat wp-config.php | grep DB_HOST | cut -d\' -f4 | rev | cut -d\: -f2 | rev)
DBPORT=$(cat wp-config.php | grep DB_HOST | rev |cut -d\: -f1 | rev | cut -d\' -f1)
PREFIX=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)

#Connect to the MYSQL Server and search for the siteurl and homeurl and set them as variables to be called later.
SITEURL=$(mysql -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASSWORD} -D ${DBNAME} -se "SELECT option_value FROM ${PREFIX}options WHERE option_name = 'siteurl';" | cut -f2)
HOMEURL=$(mysql -h ${DBHOST} -P ${DBPORT} -u ${DBUSER} -p${DBPASSWORD} -D ${DBNAME} -se "SELECT option_value FROM ${PREFIX}options WHERE option_name = 'home';" | cut -f2)

#test for config, this is using an if statement with a file test operator
# http://www.tldp.org/LDP/abs/html/fto.html
if [ -e wp-config.php ]
# if the config exists:
then
echo "we found the config data..."
echo "printing the info..."

# echoing useful stuff
echo "my dbname is ${DBNAME}"
echo "my dbuser is ${DBUSER}"
echo "my prefix is ${PREFIX}"
echo "my siteurl is ${SITEURL}"
echo "my home is ${HOMEURL}"

# if the config doesn't exist:
else
echo "we didn't find the config..."

# fi is the closing of our if statement
fi
#this is a command that will execute outside of our if statement, so regardless of whether or not it's true
echo "end of script"
)
#End of wpconfig function.




#Setting a function called debugtoggle.
#This script will toggle debug mode on and off using the wp-config.php file.
function debugtoggle () (

#Making sure config is here
if [ -e wp-config.php ]
then

#Checking to see if already toggled
if [ -e wp-config.php ] && [ -e wp-config.php.bak ]

#If already toggled on
then
echo "debug is currently on..."
echo "moving original config back..."

#here we replace the edited wp-config.php using the backup of the original file.
cp wp-config.php.bak wp-config.php

#Now lets remove the backup to keep files vanilla. 
rm wp-config.php.bak

#Quick identification of wheter or not the current setting is set as true or false.
DEBUG=$(grep -i "define( 'wp_debug" wp-config.php | cut -d\, -f2 | rev | cut -d' ' -f2 |rev)
echo "Checking... Debug is ${DEBUG}"


#If not already enabled then toggle on
else
echo "debug is currently off..."
echo "creating debug config..."
cp wp-config.php wp-config.php.bak
sed -i "/DEBUG/s/false/true/g" wp-config.php
DEBUG=$(grep -i "define( 'wp_debug" wp-config.php | cut -d\, -f2 | rev | cut -d' ' -f2 |rev)
echo "Checking... Debug is ${DEBUG}" 
fi

#If no wp-config.php is present then we will error with the following echo. 
else
echo "You are not in the install directory. Please run from install directory..."
fi
)
