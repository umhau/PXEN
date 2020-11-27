#!/bin/bash

# set -e        # exit on any error - dhcp.c considers 'no DHCP server' an error

set -v                                         # echo all lines before execution

sudo ls &>/dev/null                            # request sudo before it's needed

ndev=( `ls /sys/class/net | grep -v lo` )          # get list of network devices

s='DHCPOFFER from IP address '          # detection string for DHCP text parsing

for d in "${ndev[@]}"; do     # search network interfaces for a live DHCP server

  echo "Looking for DHCP server on $d..."                   # user communication

  ip=`sudo ./dsid -i $d -v | grep "$s" | sed "s/$s//"`   # get DHCP server IP(s)

  [[ -z "$ip" ]] || { echo -n "DHCP server IP: $ip" && break; }   # use first IP

  # TODO: handle multiple DHCP servers on different network devices. Current 
  # behavior works for 99 % of situations: only breaks if the USB is running on
  # a server connected to multiple functioning networks - breaks if first DHCP
  # server isn't the wanted one. Easy workaround: only run the USB on a machine 
  # connected only to the desired network.

done    # finished searching for IP addresses; first IP found will be in var $ip

[[ -z "$ip" ]] && echo "no DHCP server found!" && exit # TODO: start DHCP server

