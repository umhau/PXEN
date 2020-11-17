![alt text](https://github.com/umhau/pxen/blob/main/PXEN.png?raw=true)

PXE-boot a Xen hypervisor pool from a customized flash drive.

## pain point

Installing hypervisors on a large cluster, and keeping them up-to-date, is time-consuming and possibly error-prone with data loss resulting.

## design points

Specifications for all VMs is housed on the originating flash drive; these are moved to wherever they fit on the hypervisor. Parameters include CPU count, memory requirements and disk access bandwidth. (Should be possible to make that a solvable / optimizable equation.)

Thus, from a clean reboot, all hosts are turned on, and all guests loaded and started. To update the hypervisor, update the USB key and transfer the VMs. (?)

## pieces

https://www.howtogeek.com/162260/how-to-network-boot-pxe-an-automated-installation-of-citrix-xen/  Have you ever wished your Hypervisor could be installed at the push of a button, without the tedious searching for the install CD and answering the same boring installation questions? HTG explains how to PXE an automated installation of Citrix-Xen.

https://support.citrix.com/article/CTX116021 How to Set Up PXE Network Installation of XenServer Hosts.

https://web.archive.org/web/20121031051901/http://www.pearbright.com/index.php/download/25-dns-dhcp-download By permanently associating MAC and IP addresses, we ensured that both DHCP servers gave the same response to each DHCP request. Knowing the IP address of every network asset also simplified network administration, and DNS could run off the same database. 

https://serverfault.com/questions/368512/can-i-have-multiple-dhcp-servers-on-one-network Is it possible to have more than one DHCP server on the same LAN? What are the implications of doing this? 
