#!/bin/bash

set -e                                                       # exit on any error

set -v                                         # echo all lines before execution

[ `whoami` != 'root' ] && echo 'must be root!' && exit     # check for superuser

# this should be run before any subsystems are touched.

apk add sudo bash