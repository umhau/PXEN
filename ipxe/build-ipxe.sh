#!/bin/bash

# Run this on a suitable machine with the build dependencies installed. Do it 
# rarely; include the bootloader image in the git repository.  I will assume it 
# is being run on debian / ubuntu.

set -v
set -e

sudo apt-get install gcc binutils make perl xz-utils mtools liblzma-dev   # deps  # also lzma-dev ?

sudo apt-get install mkisofs syslinux     # needed only for building .iso images

[ -d ipxe ] && echo -n "dir exists. delete? > " && read && rm -rf ipxe   # check

git clone git://git.ipxe.org/ipxe.git                     # download iPXE source

cd ipxe/src                                                  # enter iPXE source

ipxe_script="demo.ipxe"                            # choose iPXE embedded script

cp -v ../../ipxe_scripts/"$ipxe_script" .     # include a custom embedded script

make bin/undionly.kpxe EMBED="$ipxe_script"                   # build iPXE image

cp -v bin/undionly.kpxe ../../                 # grab the newly built iPXE image

cd ../..                                        # cd back to main iPXE directory

