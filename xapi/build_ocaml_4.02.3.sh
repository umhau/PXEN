
sudo apk add alpine-sdk   # metapackage pulls packages for building new packages

cd ocaml

sudo mkdir -p /var/cache/distfiles 

sudo chmod a+w /var/cache/distfiles

abuild-keygen -a -i

# sudo addgroup `whoami` abuild

abuild checksum

abuild -r


# -- use the below to get the ocaml build files ------------------------------ #

# git clone git://git.alpinelinux.org/aports                 # clone aports tree

# cp -rv aports/community/ocaml .                         # copy ocaml directory
