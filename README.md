![alt text](https://github.com/umhau/pxen/blob/main/PXEN.png?raw=true)

PXE-boot a Xen hypervisor pool from a customized flash drive.

## pain point

Installing hypervisors on a large cluster, and keeping them up-to-date, is:

- time-consuming, 
- complicated, 
- requires re-doing custom configurations after updates,  
- and is possibly error-prone with the risk of data loss.

## value

Reduction of complexity into simplicity.

- Boot once & run everywhere: no tedious installations on every update
- Easy to maintain an updated cluster
- Totally deterministic state
- Fully documented cluster state in a single, central location

## design points

### boot process architecture

Assumption: that the difference between primary and secondary xen hosts is limited to a couple of settings that can be easily changed. The passive primary host identification used below ensures that the same boot files can be used on the first machine as with all the others, and may simplify the architecture.

- machine boots, either from the initial customized USB flash drive or with PXE. The root filesystem (which is a ready-to-use xen hypervisor, _not_ an installer) is copied into a RAMdisk,  and the OS root is changed to that disk. If a hostname ID list is available, it is used to determine the hostname; otherwise, the hostname is randomized (or it's generated deterministically from the motherboard ID, in which case the list is superfluous).
- The machine is now available for access through xcp-ng center.
- the attached drives are mounted and searched. All VMs and SRs found are not started, but are made available to be seen in xcp-ng center and xen orchestra.
- if the source flash drive is found, and verified, then the machine identifies itself as the host0 and primary member of the hypervisor pool. It uses the files on the flash drive to host the PXE boot server. If a MAC address boot list is available, it sends wake-on-LAN signals to all addresses in the list. It uses the files on the flash drive to start and host the xen-orchestra virtual machine.
- All PXE-booted machines are referred to as hostU. The boot-search process repeats. If a source flash drive is found, it must not successfully verify.
- At this point, xen orchestra and xcp-ng center should be able to manage the entire pool.

Thoughts on verification of the source flash drive:

- A file is placed on the flash drive, to identify it as the source for the cluster. This file should have sufficient IDs that it cannot be mistaken or faked without sufficient effort that the duplication must be intentional. 
- It may also be useful to make that identification file easy to fake.  Are there use-cases where multiple host0s are wanted, or a different server from the usb booted one is wanted as the host0? Maybe, the host0 should only be host0 as long as that flash drive is inserted - it serves as a sort of key, and the whole pool crashes if it's removed. (Great way to insert unneeded fragility)
- There should be a way to differentiate multiple similar boot disks that are connected - what if the flash drive is switched with another, with different settings, between steps 2 and 6? Make sure that it is impossible for the cluster to enter an error state with multiple host0 machines.
- What happens if an identical flash drive is connected to a secondary machine? -- a hash should be dropped on the flash drive with the date, time, machine id, so having an identical, validated flash drive becomes impossible.

Note that the flash drive should contain several files that are modified both by the sysadmin and by the host0 (in communication with the hostUs). It may be convenient to put an NTFS or FAT32 partition at the beginning of the drive, and put all user-modified files in there. If the files are unreadable or unsuitable due to user error, backups can be put elsewhere and big warnings in bright letters put everywhere.

- list of MAC addresses associated with each machine - for wake-on-LAN
- list of machine identifiers (motherboard serials?) to associate hostnames with previously-seen machines. useful to maintain continuity over reboots. Or, generate the hostnames from the motherboard serials, and then they will maintain continuity automatically.
- ssh key and/or password: if the `/etc/shadow` file is part of the standard filesystem, then the same accounts should exist accross all the machines. Is this a security risk? Probably not, at least not within my vague idea of the threat model involved. 

### misc

Specifications for all VMs is housed on the originating flash drive; these are moved to wherever they fit on the hypervisor. Parameters include CPU count, memory requirements and disk access bandwidth. (Should be possible to make that a solvable / optimizable equation.)

The system can even be used when there's only one host: when it boots, it puts the OS filesystem in RAM and then goes through the same VM & SR discovery process as any other secondary host.

Thus, from a clean reboot, all hosts are turned on, and all guests loaded and started. To update the hypervisor, update the USB key and transfer the VMs. (?)

RAID devices on each hypervisor host are automatically mounted. 

Where are VMs stored? 

Among the lists of information maintained on the central boot drive, keep a record of all MAC addresses assocated with the pool members. Once that's in place, the secondary hypervisor hosts can be started with wake-on-LAN.

Since we can't assume the network is stable, remember to copy all system files into ramdisks during the boot process.

## pieces

### DHCP considerations

https://web.archive.org/web/20121031051901/http://www.pearbright.com/index.php/download/25-dns-dhcp-download By permanently associating MAC and IP addresses, we ensured that both DHCP servers gave the same response to each DHCP request. Knowing the IP address of every network asset also simplified network administration, and DNS could run off the same database. 

https://serverfault.com/questions/368512/can-i-have-multiple-dhcp-servers-on-one-network Is it possible to have more than one DHCP server on the same LAN? What are the implications of doing this? 

### PXE booting 

https://serverfault.com/questions/842703/xenserver-7-1-0-pxe-installation I'm trying to set up a PXE boot of the XenServer 7.1.0 installation. I'm following Citrix Installation Guide Appendix C on pages 37ff. My Blade is booting to a grub console, but not loading the install system.

https://wiki.syslinux.org/wiki/index.php?title=Mboot.c32 mboot.c32 is a Syslinux module that loads images using the Multiboot specification. A really good use case for this is booting Xen, or any other hypervisor-based virtualization pieces that also require an initrd/initramfs. If your Xen boot doesn't require an initrd, then it is possible to utilize the existing kernel/append method.

https://support.citrix.com/article/CTX116021 How to Set Up PXE Network Installation of XenServer Hosts.

https://www.howtogeek.com/162260/how-to-network-boot-pxe-an-automated-installation-of-citrix-xen/  Have you ever wished your Hypervisor could be installed at the push of a button, without the tedious searching for the install CD and answering the same boring installation questions? HTG explains how to PXE an automated installation of Citrix-Xen.

### maintaining VMs accross reboots

https://support.citrix.com/article/CTX132387 Recovering Virtual Machines from Failed Pool Member. In the event of a XenServer host power failure, any Virtual Machines (VMs) running on that host might not be displayed in XenCenter. 

https://support.citrix.com/article/CTX136342 This article describes how to reinstall a XenServer host and preserve Virtual Machines (VMs) on the local storage.
Sometimes re-installation of XenServer is required to obtain a clean system state or to recover from a serious failure (such as a database file corruption), where VMs residing on local storage must be preserved and recovered within a reasonable amount of time.

https://support.citrix.com/article/CTX125769 This article describes how to restore metadata for an individual Virtual Machine (VM). The current VM metadata restore process does not allow you to restore metadata for individual VMs.
