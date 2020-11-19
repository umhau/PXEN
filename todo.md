## todo

focus on the PXE boot first. Get it working, document the process, script it. Two scripts: the build script, that pulls the files required, and the serve script, that sets up the server.  Just one script to start with, just get it working deterministically.

- the TFTP server serves a gpxe bootloader. gpxe has been superceded by ipxe, which is a fork. There is no longer a tool to generate a custom pxe bootloader, so it will have to be built from scratch.

https://ipxe.org/download

- must find a way to serve PXE files without modifying the DHCP server. 

- can I make dnsmasq auto-detect the network range? Right now the dnsmasq.conf file needs the network to be hardcoded.


## alpine versions

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-xen-3.12.1-x86_64.iso Built-in support for Xen Hypervisor. Includes packages targetted at Xen usage. Use for Xen Dom0. 


http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-netboot-3.12.1-x86_64.tar.gz Kernel, initramfs and modloop for netboot. 

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-standard-3.12.1-x86_64.iso Alpine as it was intended. Just enough to get you started. Network connection is required. 

http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-extended-3.12.1-x86_64.iso Most common used packages included. Suitable for routers and servers. Runs from RAM. 