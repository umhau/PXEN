# outline of scripts

pxen.sh

This runs on startup, and manages the main logic. It determines whether it's 
running on a USB or a network boot, looks for a host0, decides if it should
become a host0, examines the local disks and mounts them if needed.

host0.sh

Is run on startup when the USB boots or the machine is otherwise determined to 
be the host0. Turns on dhcp server, tftp server, etc. 

build.sh

This creates the usb image. Does its own weird version of installations, etc.
