# todo

## current state

Have not yet tried to start the server; still wrapping my head around how it's supposed to work, and what code is supposed to go where, and where to put variables so that I avoid hardcoding anything.

The proxy-DHCP code is broken. Working on fixing it; forked the repo and am doing repairs. 

## task list

1. focus on the PXE boot first. Get it working, document the process, script it. Two scripts: the build script, that pulls the files required, and the serve script, that sets up the server.  Just one script to start with, just get it working deterministically.

- [ ] the TFTP server serves a gpxe bootloader. gpxe has been superceded by ipxe, which is a fork. There is no longer a tool to generate a custom pxe bootloader, so it will have to be built from scratch.  https://ipxe.org/download

- [ ] fix the proxy DHCP server tool I found. Looks like there's a bug in the network device detection code; does that bode ill for the quality of the rest of the program? Could be an age thing, in which case it's only the interface between the software and the protocol that's at risk. It prevented even starting the software, which implies that it must be age.

- [ ] make the proxy DHCP auto-detect the network range. Right now DHCP server uses a hardcoded network.

2. Once _something_ boots, work on a) specifying what it is I want to boot, and b) make the usb & server run alpine.

### later - not MVP

- get XAPI working. That involves getting the build environment functional.

## alpine versions

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-xen-3.12.1-x86_64.iso Built-in support for Xen Hypervisor. Includes packages targetted at Xen usage. Use for Xen Dom0. 

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-netboot-3.12.1-x86_64.tar.gz Kernel, initramfs and modloop for netboot. 

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso Alpine as it was intended. Just enough to get you started. Network connection is required. 

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-extended-3.12.1-x86_64.iso Most common used packages included. Suitable for routers and servers. Runs from RAM. 