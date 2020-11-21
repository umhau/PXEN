#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` != 'root' ] && echo 'must be root!' && exit     # check for superuser

apk add lighttpd                                                  # dependencies

cp /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.orig   # back up conf

rc-service lighttpd start                         # start the lighthttpd service

mkdir -pv /var/www/localhost/htdocs/prov/          # make subdir for ipxe script

cp ipxe-script /var/www/localhost/htdocs/prov/ipxe-script   # copy to served dir

