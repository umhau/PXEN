#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

sudo apk add gcc python2 git                                      # dependencies

gcc dhcp.c -o dsid                          # compile the DHCP server identifier

sudo install dsid /usr/local/bin/                   # install it for easy access

rm -rf proxyDHCPd            # remove potential extant version of the dhcp proxy

git clone https://github.com/umhau/proxyDHCPd.git     # download proxy DHCP tool

