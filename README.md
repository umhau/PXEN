![alt text](https://github.com/umhau/pxen/blob/main/PXEN.png?raw=true)

PXE-boot a Xen hypervisor cluster from a customized flash drive.

## pain point

Installing hypervisors on a large cluster, and keeping them up-to-date, is:

- time-consuming, 
- complicated, 
- requires re-doing custom configurations after updates,  
- and possibly error-prone with the risk of data loss.

## value

Reduction of complexity into simplicity.

- Boot once & run everywhere: no tedious installations on every update
- Easy to maintain an updated cluster
- Totally deterministic state
- Fully documented cluster state in a single, central location
- All configurations are maintained in a single location and automatically deployed.

## design / architecture principles

- extreme reliability
- extreme simplicity
- extreme resiliency

i.e.

- all scripts and programs should be easy to pick up and read.
- a minimum of scripts and programs should be required.
- the architecture should be understandable from first principles.
- everything is deterministic.
- every line of code is documented, and follows logically.
- every possible failure mode should be considered at every line of code.
- every line of code revolves around maximizing uptime and getting online in the minimum of time.

metrics:

- minimum downtime in the face of the chaos monkey
- minimum startup time
- minimize time-to-management-console-availability
- minimize time-to-last-host-online

the fallacies:

- The network is reliable;
- Latency is zero;
- Bandwidth is infinite;
- The network is secure;
- Topology doesn't change;
- There is one administrator;
- Transport cost is zero;
- The network is homogeneous.

Examine every line of code for these assumptions. Note, however, that we do assume the network is appropriate for a xen hypervisor cluster.

## design points

What if I used MPI for inter-host communication? Is that useful, or just extra complexity?

### boot process architecture

Assumption: that the difference between primary and secondary xen hosts is limited to a couple of settings that can be easily changed. The passive primary host identification used below ensures that the same boot files can be used on the first machine as with all the others, and may simplify the architecture.

Note: once all machines are booted, the machine with the flash drive and the PXE boot server should not be considered any different from all the other machines. It _should not_ be considered a primary server in a pool, and the collection of booted machines should not be put in a pool together. That can all be done in the management consoles after the fact, and the states decided on saved to the flash drive.

- machine boots, either from the initial customized USB flash drive or with PXE. The root filesystem (which is a ready-to-use xen hypervisor, _not_ an installer) is copied into a RAMdisk,  and the OS root is changed to that disk. If a hostname ID list is available, it is used to determine the hostname; otherwise, the hostname is randomized (or it's generated deterministically from the motherboard ID, in which case the list is superfluous).
- The machine is now available for access through xcp-ng center.
- the attached drives are mounted and searched. All VMs and SRs found are not started, but are made available to be seen in xcp-ng center and xen orchestra.
- if the source flash drive is found, and verified, then the machine identifies itself as the host0 and primary member of the hypervisor pool. It uses the files on the flash drive to host the PXE boot server. If a MAC address boot list is available, it sends wake-on-LAN signals to all addresses in the list. It uses the files on the flash drive to start and host the xen-orchestra virtual machine.
- All PXE-booted machines are referred to as hostU. The boot-search process repeats. If a source flash drive is found, it must not successfully verify.
- At this point, xen orchestra and xcp-ng center should be able to manage the entire pool.

Thoughts on verification of the source flash drive:

- A file is placed on the flash drive, to identify it as the source for the cluster. This file should have sufficient IDs that it cannot be mistaken or faked without sufficient effort that the duplication must be intentional. 
- It may also be useful to make that identification file easy to fake.  Are there use-cases where multiple host0s are wanted, or a different server from the usb booted one is wanted as the host0? Maybe, the host0 should only be host0 as long as that flash drive is inserted - it serves as a sort of key, and the whole pool crashes if it's removed. (Great way to insert unneeded fragility)
  - if multiple pools are wanted, then the primary host of each pool could/should boot from a flash drive? In this case, another list should be maintained of the hosts in each pool. If a host is to be added to a pool, it's done in xcp-ng center, and then the host0 automatically adds it to an internal list. Otherwise, the hosts are PXE booted and remain separate until added together. 
  - what happens if you boot two machines from usbs independently? they both consider themselves host0s, and try to host PXE boot servers. Then you have PXE boot servers competing.
- There should be a way to differentiate multiple similar boot disks that are connected - what if the flash drive is switched with another, with different settings, between steps 2 and 6? Make sure that it is impossible for the cluster to enter an error state with multiple host0 machines.
- What happens if an identical flash drive is connected to a secondary machine? -- a hash should be dropped on the flash drive with the date, time, machine id, so having an identical, validated flash drive becomes impossible.

Note that the flash drive should contain several files that are modified both by the sysadmin and by the host0 (in communication with the hostUs). It may be convenient to put an NTFS or FAT32 partition at the beginning of the drive, and put all user-modified files in there. If the files are unreadable or unsuitable due to user error, backups can be put elsewhere and big warnings in bright letters put everywhere.

These 'state files' might benefit from a format / syntax similar to nix or lisp, especially if there's a need to specify configurations (or configuration files) that are specific to subsets of hosts.  

In general, these files will be provided to all machines in the cluster, in their entirety.  If that's a problem, later versions of the tool can make breaking changes to adjust that.

- list of MAC addresses associated with each machine - for wake-on-LAN
- list of machine identifiers (motherboard serials?) to associate hostnames with previously-seen machines. useful to maintain continuity over reboots. Or, generate the hostnames from the motherboard serials, and then they will maintain continuity automatically.
- ssh key and/or password: if the `/etc/shadow` file is part of the standard filesystem, then the same accounts should exist accross all the machines. Is this a security risk? Probably not, at least not within my vague idea of the threat model involved. 
- list of machines and the pools they're in, and which machines are the primaries of the pool. This is based on the deterministic hostnames. It also means that pools and primary machines _should not_ be determined by the machine with the flash drive in it.

### misc

Specifications for all VMs is housed on the originating flash drive; these are moved to wherever they fit on the hypervisor. Parameters include CPU count, memory requirements and disk access bandwidth. (Should be possible to make that a solvable / optimizable equation.)

The system can even be used when there's only one host: when it boots, it puts the OS filesystem in RAM and then goes through the same VM & SR discovery process as any other secondary host.

Thus, from a clean reboot, all hosts are turned on, and all guests loaded and started. To update the hypervisor, update the USB key and transfer the VMs. (?)

RAID devices on each hypervisor host are automatically mounted. 

Where are VMs stored? 

Among the lists of information maintained on the central boot drive, keep a record of all MAC addresses assocated with the pool members. Once that's in place, the secondary hypervisor hosts can be started with wake-on-LAN.

Since we can't assume the network is stable, remember to copy all system files into ramdisks during the boot process.

## pieces

https://support.citrix.com/article/CTX128391 This article describes how to remove a server from a XenServer pool that contains only one server. 

### DHCP considerations

There's two ways to go w.r.t. DHCP: either it's run from one of the initial machines, or it's run by a router external to the cluster. The problem is, in case of a power outage, the entire cluster will be down until the DHCP server is back online. Is there a way to do a temporary DHCP server, when the main one isn't available? Is there a way to do direct connections, possibly with MAC addresses?

Obviously, version 1 of PXEN will be dependent on an external DHCP server. Everything that follows in this section is a resilience extra that will be added later.

https://softwareengineering.stackexchange.com/questions/309546/connecting-directly-to-another-computer-knowing-only-the-mac-address It looks like I could have a fail-over system:

- check if there's a DHCP server responding to requests. If there is, all's well with the world, use it.
- If no DHCP server available (e.g., the cluster is connected through a switch but there's no router), then:
  - If there's a list of MAC addresses available, use them to set static IPs and initiate direct connections between the servers.
  - Also potentially possible to sniff the local traffic? Emulate a DHCP server?
  - Send out special packets to try and find other servers?
  - Use randomized IPV6 addresses, since those would virtually never overlap, and use those to initiate direct connections with the other servers. Use special packets broadcasted through the network to find the other servers. (Could probably encrypt them with the SSH key, too)
  - Somehow or other, set up a communication network.
  - When a DHCP server is back online, change the IP addresses to what the DHCP server hands out. Convert them internally, so there's no missed connections. 
- Before this is pursued farther, figure out exactly what the scenario is supposed to be. What's the threat, what's expected / hoped to happen? -- cluster is back online immediately after the power is on, and reconnects with the rest of the infrastructure as it reappears.

https://web.archive.org/web/20121031051901/http://www.pearbright.com/index.php/download/25-dns-dhcp-download By permanently associating MAC and IP addresses, we ensured that both DHCP servers gave the same response to each DHCP request. Knowing the IP address of every network asset also simplified network administration, and DNS could run off the same database. 

https://serverfault.com/questions/368512/can-i-have-multiple-dhcp-servers-on-one-network Is it possible to have more than one DHCP server on the same LAN? What are the implications of doing this? 

### PXE booting 

https://support.citrix.com/article/CTX217677 Configuring your TFTP Server for PXE boot - XenServer. A sample configuration that performs an unattended installation using the answer file at the URL specified.

https://serverfault.com/questions/842703/xenserver-7-1-0-pxe-installation I'm trying to set up a PXE boot of the XenServer 7.1.0 installation. I'm following Citrix Installation Guide Appendix C on pages 37ff. My Blade is booting to a grub console, but not loading the install system.

https://wiki.syslinux.org/wiki/index.php?title=Mboot.c32 mboot.c32 is a Syslinux module that loads images using the Multiboot specification. A really good use case for this is booting Xen, or any other hypervisor-based virtualization pieces that also require an initrd/initramfs. If your Xen boot doesn't require an initrd, then it is possible to utilize the existing kernel/append method.

https://support.citrix.com/article/CTX116021 How to Set Up PXE Network Installation of XenServer Hosts.

https://www.howtogeek.com/162260/how-to-network-boot-pxe-an-automated-installation-of-citrix-xen/  Have you ever wished your Hypervisor could be installed at the push of a button, without the tedious searching for the install CD and answering the same boring installation questions? HTG explains how to PXE an automated installation of Citrix-Xen.

### maintaining VMs accross reboots

https://support.citrix.com/article/CTX132387 Recovering Virtual Machines from Failed Pool Member. In the event of a XenServer host power failure, any Virtual Machines (VMs) running on that host might not be displayed in XenCenter. 

https://support.citrix.com/article/CTX136342 This article describes how to reinstall a XenServer host and preserve Virtual Machines (VMs) on the local storage.
Sometimes re-installation of XenServer is required to obtain a clean system state or to recover from a serious failure (such as a database file corruption), where VMs residing on local storage must be preserved and recovered within a reasonable amount of time.

https://support.citrix.com/article/CTX125769 This article describes how to restore metadata for an individual Virtual Machine (VM). The current VM metadata restore process does not allow you to restore metadata for individual VMs.

## breaking changes, deferred for later

- A better identification system for hosts, beyond motherboard serial numbers. The ID will be critical when dealing with restoring VMs, and distributing saved metadata.
- DHCP and subnet configurations.
- flash drive architecture
- configuration file syntax
