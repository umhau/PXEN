#!/bin/bash


# -- use the below to get the ocaml build files ------------------------------ #

# git clone git://git.alpinelinux.org/aports                 # clone aports tree

# cp -rv aports/community/ocaml .                         # copy ocaml directory

# what we have is modified heavily from what is downloaded in the above lines

# ---------------------------------------------------------------------------- #

# sudo addgroup `whoami` abuild                   # if not done, build will fail

sudo apk add alpine-sdk   # metapackage pulls packages for building new packages

cd ocaml                          # enter directory with build instructions file

sudo mkdir -p /var/cache/distfiles     # create file where temp build stuff goes

sudo chmod a+w /var/cache/distfiles         # make sure the permissions are good

abuild-keygen -a -i         # you need a key to sign your version of the package

abuild checksum      # use the key to make the checksum which marks it unchanged

abuild -r                                                             # build it

# the files will be somewhere in ~/packages 

