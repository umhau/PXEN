![alt text](https://github.com/umhau/pxen/blob/main/PXEN.png?raw=true)

PXE-boot a Xen hypervisor pool from a customized flash drive.

## pain point

Installing hypervisors on a large cluster, and keeping them up-to-date, is time-consuming and possibly error-prone with resulting data loss.

## value

Reduction of complexity into simplicity.

- Boot once & run everywhere: no tedious installations on every update
- Easy to maintain updated cluster
- Totally deterministic state
- Fully documented cluster state in a single, central location

## design points

Specifications for all VMs is housed on the originating flash drive; these are moved to wherever they fit on the hypervisor. Parameters include CPU count, memory requirements and disk access bandwidth. (Should be possible to make that a solvable / optimizable equation.)

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
