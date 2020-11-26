#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

sudo apk add python2 git   # python 2.X: compatible with 10-year-old python tool

rm -rf proxyDHCPd                           # remove the old version of the tool

git clone https://github.com/umhau/proxyDHCPd.git         # pull proxy DHCP tool

cd proxyDHCPd                                    # enter directory to install it

python setup.py   # install proxyDHCPd: this provides the DHCP responses for PXE

cd ..                                              # back to main DHCP directory

