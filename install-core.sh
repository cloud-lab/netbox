#!/bin/bash

echo
if [ ! "${USER}" = "root" ] ; then
   echo -e "Type $(tput setaf 1)sudo ./install.sh$(tput sgr0) for installation"
   exit 0 ; fi

exec >  >(tee -a /tmp/install.log)
exec 2> >(tee -a /tmp/install.log >&2)

apt-get update
# Install postgresql and core-dev apps
core_apps=$(echo "postgresql build-essential libpq-dev libxml2-dev libxslt1-dev libffi-dev libssl-dev graphviz zlib1g-dev")
for a in $core_apps; do
     echo $(tput setaf 6)
     echo "Installing $a .... Please wait .... "$(tput sgr0)
     sudo apt-get -qq -y install $a
done

echo $(tput setaf 6)
echo "!!-- All core installation have finished --!!"$(tput sgr0)

systemctl start postgresql
systemctl enable postgresql

echo $(tput setaf 6)
echo "Create database with following commands: (; at the end)"
echo $(tput setaf 3)
echo "sudo -u postgres psql"
echo "CREATE DATABASE netbox;"
echo "CREATE USER sysadmin WITH PASSWORD '?????';"
echo "GRANT ALL PRIVILEGES ON DATABASE netbox TO sysadmin;"
echo $(tput setaf 6)
echo "Enter \q to quit"
echo "Login database again to confirm"
echo $(tput setaf 3)
echo "psql -U sysadmin -W -h localhost netbox"
echo $(tput sgr0)
