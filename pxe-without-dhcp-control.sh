#!/bin/bash

# This is intended to run on alpine linux. Clone the repo to an alpine VM, then
# run this script. When it completes, the VM will be able to host network 
# boots of alpine linux. Not installation disks, but a ready-to-run OS.  This 
# will require NFS drives, or some other (more reliable) method of obtaining the
# system files. 

# Thus, this script may become an umbrella for two others: one to set up PXE,
# and one to build the alpine linux OS to be served.

# This script is run under the assumption that the DHCP server is already 
# running and not under our control. If another PXE server is running, nothing
# will work.

set -e
set -v 

apk add tftp-hpa dnsmasq                                          # dependencies

mkdir -pv /var/tftproot/                           # create TFTP file serve path

cp ipxe/ipxe.kpxe /var/tftproot/          # place iPXE image in TFTP file server

# sources: how to set up proxy PXE

# http://howto.basjes.nl/linux/doing-pxe-without-dhcp-control

# https://manski.net/2016/09/pxe-server-on-existing-network-dhcp-proxy-on-ubuntu/

# http://etherboot.org/wiki/proxydhcp

# https://www.theurbanpenguin.com/pxelinux-using-proxy-dhcp/

# https://gmagno.dev/2019/05/quick-setup-of-a-proxydhcp-with-dnsmasq-and-pxe-boot/
# this one talks about using xenserver

dnsmasq -d                                                       # start dnsmasq