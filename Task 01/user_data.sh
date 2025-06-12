#!/bin/sh
#
# Initialize Web Server on instance creation

WWW_HOME="/usr/local/apache24"
export WWW_HOME

yes | pkg update
pkg install -y apache24
sysrc enable apache24
service start apache24

echo "Hello World from $(uname -n)" > ${WWW_HOME}/data/index.html
chmod 644 ${WWW_HOME}/data/index.html

exit 0
