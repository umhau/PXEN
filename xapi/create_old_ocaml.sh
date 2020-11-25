
sudo apk add alpine-sdk   # metapackage pulls packages for building new packages

[ -d aports ] || git clone git://git.alpinelinux.org/aports  # clone aports tree

cd aports/community/ocaml

# cd ocaml

sudo mkdir -p /var/cache/distfiles 

sudo chmod a+w /var/cache/distfiles

abuild-keygen -a -i

# sudo addgroup `whoami` abuild

# abuild checksum

abuild -r