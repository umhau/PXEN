#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` != 'root' ] && echo 'must be root!' && exit     # check for superuser

apk add mkinitfs                                                  # dependencies

# WHERE IS IT? the mkinitfs profile just for networking called: network

# ask IRC: how do I add all possible network drivers? If I don't know what hw
# I'll be encountering.
# website says do this: kernel/drivers/net/ethernet/intel/e1000/*.ko
# what if I do this? kernel/drivers/net/ethernet/*/*/*.ko

cp network.modules /etc/mkinitfs/features.d/    # add drivers for ethernet cards

cp dhcp.modules /etc/mkinitfs/features.d/        # enable DHCP in the new kernel

cp nfs.modules /etc/mkinitfs/features.d/          # enable NFS in the new kernel

mkinitfs -o /srv/http/prov/pxerd                 # generate a PXE-capable initrd

