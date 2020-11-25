
sudo apk add alpine-sdk   # metapackage pulls packages for building new packages

[ -d aports ] || git clone git://git.alpinelinux.org/aports  # clone aports tree

cd aports/community/ocaml

