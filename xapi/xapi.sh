#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` == 'root' ] && echo 'must NOT be root!' && exit # check for superuser

rm -rf xen-api                                       # remove if already present

git clone https://github.com/xapi-project/xen-api.git # Pull the XAPI repository

cd xen-api

git checkout 5ba6c01e485c61eefb69e520e641a918653ee2d1  # checkout latest release

mv ./configure ./configure.original && cp ../configure ./       # use my version

chmod +x ./configure

./configure                                       # run the configuration script

# dune external-lib-deps --missing -j 1 --profile release @install

make