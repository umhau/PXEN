#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` != 'root' ] && echo 'must be root!' && exit     # check for superuser

apk add python2 git        # python 2.X: compatible with 10-year-old python tool

git clone https://github.com/umhau/proxyDHCPd.git         # pull proxy DHCP tool

cd proxyDHCPd                                    # enter directory to install it

python setup.py   # install proxyDHCPd: this provides the DHCP responses for PXE

cd ..                                              # back to main DHCP directory

