#!/bin/bash

# version='4.02.3'

version='4.04.1'


# sudo addgroup `whoami` abuild # if not done, build will fail. Logout/in after.

sudo apk add alpine-sdk   # metapackage pulls packages for building new packages

cd ocaml_build_$version           # enter directory with build instructions file

sudo mkdir -pv /var/cache/distfiles    # create file where temp build stuff goes

sudo chmod a+w /var/cache/distfiles         # make sure the permissions are good

abuild-keygen -a -i         # you need a key to sign your version of the package

abuild checksum      # use the key to make the checksum which marks it unchanged

abuild -r                                                             # build it

# the files will be somewhere in ~/packages.

