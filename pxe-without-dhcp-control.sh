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

# install dependencies

# make needed folders

# ???

apk add tftp-hpa                                           # install TFTP server






# Install a TFTP server (package "tftp-hpa"). You will need to place a gPXE image at /var/tftproot/gpxe.kpxe. You can generate an image online at ROM-o-matic.eu. Select the ".kpxe" output format and the "undionly" driver. You will need to specify a custom boot script. Select "Customize". The following boot script works well:

#  dhcp net0
#  chain http://${net0/next-server}/gpxe-script

# You can include ${net0/mac} and ${uuid} in the URL for the interface MAC address and machine UUID respectively.

# Note that as of writing, ROM-o-matic appears to produce a buggy image unless it is used with the "undionly" driver. If you require a different driver, consider building gPXE yourself, especially if you experience inexplicable connectivity issues. Common symptoms are a seemingly correctly configured, randomly functional network connection which appears to suffer from extreme packet loss. 
