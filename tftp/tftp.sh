#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` != 'root' ] && echo 'must be root!' && exit     # check for superuser

apk add tftp-hpa                                                  # dependencies

mkdir -pv /var/tftproot/                           # create TFTP file serve path

cp ipxe/ipxe.kpxe /var/tftproot/          # place iPXE image in TFTP file server

rc-service in.tftpd start                        # start the TFTP daemon service

