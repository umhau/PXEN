#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` == 'root' ] && echo 'must NOT be root!' && exit # check for superuser

# -- apk-sourced packages ---------------------------------------------------- #

sudo apk add ocaml=4.02.3                     # pin ocaml to the version we need

sudo cp -v ./repositories /etc/apk/repositories       # Add community repository

sudo apk add git opam nano wget tar make ocaml-compiler-libs              # deps

sudo apk add dune gmp-dev perl pkgconf xen-dev       # needed for making zen-api

sudo apk add libc-dev                               # needed for installing dune

sudo apk add ocaml-ocamldoc                             # needed for zenith, &c.

# stdext xapi-netdev xapi-stdext-monadic

# -- opam-sourced packages --------------------------------------------------- #

opam init                              # Initialize opam. Just keep hitting 'y'.

eval $(opam env)                                               # Initialize opam

# opam pin https://github.com/umhau/ppx_custom_printf.git            # fixed a bug

opam install dune base64 ppxlib async js_of_ocaml-ppx lwt       # ocaml-rpc deps

opam install cow cmdliner rresult yojson xmlm              # more ocaml-rpc deps

# rm -rf ocaml-rpc                               # in case an old version is there

# git clone https://github.com/NathanReb/ocaml-rpc.git   # this dude fixed the bug

# cd ocaml-rpc; git checkout d8f0244d5ea3bb13a37a94d5b6749a6fd82ab459; cd .. # fix

# opam pin ocaml-rpc#HEAD                              # install the fixed version

# opam repo add xs-opam https://github.com/xapi-project/xs-opam.git    # xapi repo


# dependencies needed for message-switch
opam install cohttp-async cohttp-lwt-unix lwt_log mirage-block-unix shared-block-ring

# these deps might give a clue as to the correct ocaml version.
#   - cohttp-async → async < v0.12 → ppx_jane < v0.12 → ocaml = 4.02.3
#   - cohttp-async → async < v0.12 → ppx_jane < v0.12 → ppx_custom_printf < v0.12
#   - cohttp-async → async < v0.12 → ocaml < 4.03
#   - cohttp-async → async_kernel → ppx_jane → ocaml = 4.02.3




# rm -rf message-switch
# git clone git://github.com/xapi-project/message-switch
# cd message-switch
# mv ./configure ./configure.original && cp ../configure ./       # use my version
# chmod +x ./configure
# ./configure                                       # run the configuration script
# make
# cd ..
# opam pin message-switch#HEAD

# # 


opam install alcotest astring cdrom ctypes ezxenstore gzip http-svr message-switch-unix mtime pciutil ppx_deriving_rpc ppx_sexp_conv rpclib rrdd-plugin sexpr sha stunnel tar tar-unix uuid uuidm x509 xapi-idl xapi-inventory xapi-stdext-date xapi-stdext-encodings cmdliner ocamlfind xapi-stdext-pervasives xapi-stdext-std xapi-stdext-threads xapi-stdext-unix xapi-tapctl xapi-test-utils xapi-xenopsd xenctrl xml-light2 yojson http-svr xapi-idl js_of_ocaml-ppx base64 ppxlib async lwt cow rresult xmlm http-svr ppx_deriving_rpc

# extant failures: systemd, message-switch-core (sometimes...), xapi-inventory


# hold then delete

# apk add m4                            # needed for findlib ocaml package manager

# apk add libc-dev ocaml-compiler-libs                   # deps for making findlib

# wget http://download.camlcity.org/download/findlib-1.8.1.tar.gz    # get findlib

# tar xvzf findlib-1.8.1.tar.gz                                          # extract

# cd findlib-1.8.1                                               # enter directory

# ./configure                        # this should figure out a good configuration

# make all               # This creates findlib.cma, findlib_mt.cma, and ocamlfind

# make opt         # This creates findlib.cmxa, findlib_mt.cmxa, and ocamlfind_opt

# make install                              # installs the newly compiled binaries 

# make clean                                       # cleans up the build directory