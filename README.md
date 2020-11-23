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

## user experience

Download & burn an ISO, boot it, go turn on your servers, and open up your management console. Hey presto, your cluster is running. 

After a power outage, boot the same flash drive again and watch as your whole cluster automagically turns back on and restores its state.

For extra redundancy, I could host a service for holding the cluster metadata. Then you can use a fresh disk image, that's been primed with your user ID & authentication, and you don't have to worry about the flash drive dying. 

## add-ons

There's a lot of cluster tools that run on top of a group of machines. Might be worthwhile to include the option to install them on the nodes.

- kubernetes
- xcp
- cluster-manager-of-the-day

Also, try using guix. I think it would make a lot of things way easier. https://news.ycombinator.com/item?id=25187576

## how to use

There's a lot of components to build, but to use the tool just download the image.

### building the whole thing from scratch

Most of these steps are taken from the [Alpine Linux PXE boot howto](https://wiki.alpinelinux.org/wiki/PXE_boot). 

The ultimate (later, not MVP, not super important) goal is that the downloadable and bootable USB image should be capable of building the whole system - stick this repo in `/opt/PXEN/` and make sure all the needed packages are installed on the OS that boots from the flash drive.  Benefit: helps with ensuring the system is deterministic, and that it will always be possible to build the tool regardless of code rot.

0. Clone the repo.

```
git clone https://github.com/umhau/PXEN.git
cd PXEN
```

1. Set up a DHCP server and configure it to support PXE boot.

```
cd dhcp


```

sources: how to set up proxy PXE

http://howto.basjes.nl/linux/doing-pxe-without-dhcp-control

https://manski.net/2016/09/pxe-server-on-existing-network-dhcp-proxy-on-ubuntu/

http://etherboot.org/wiki/proxydhcp

https://www.theurbanpenguin.com/pxelinux-using-proxy-dhcp/

https://gmagno.dev/2019/05/quick-setup-of-a-proxydhcp-with-dnsmasq-and-pxe-boot/
this one talks about using xenserver


2. Obtain / build the PXE bootloader.  

You don't need to build a new bootloader unless the custom script has changed. A default is already built.

```
cd ipxe
bash build.ipxe_image.sh
cd ..
```

3. Set up a TFTP server to serve the PXE bootloader.

```
cd tftp
bash tftp.sh
cd ..
```

4. Set up an HTTP server to serve the rest of the boot files.

```
cd http.sh
bash http.sh
cd ..
```

5. Set up an NFS server from which Alpine can load kernel modules.

```
cd nfs
bash nfs.sh
cd ..
```

6. Configure mkinitfs to generate a PXE-bootable initrd.



### just download the USB ISO

Pull it from the (so far nonexistent) releases page.

## security

There isn't much of a threat model here. However, it may be useful to read through this: https://wiki.alpinelinux.org/wiki/Setting_up_a_laptop

## variation

Let the hosts run a proper window system, so that they can be used as user-facing systems in their own right. In that use case, VMs might still be needed, but they'll need to be able to be accessed on the host they're running from. I think VNC is the way to make that work? Xen doesn't really make local VM access a priority.

https://wiki.xen.org/index.php?title=Xen_Project_Beginners_Guide#Starting_a_GUI_guest_.28with_VNC_server.29

Once that's out of the way, multiple computers can be run from the same core of the network and they'll be secure and deterministic.

i.e., this variation involves the same technology implemented in the same way, but has a totally different use case. 

## stayin' alive

- Free software, paid consulting.

- Extended edition, pay extra for it: build a system to upload relevant metadata and host boot images to my server: the flash drive could be reduced to a prompt to make the hostU's download everything from the web, where all the configuration happens.

  - this assumes the use case doesn't involve downed internet, or security

  - Website where you choose the VMs that should run, and which - if any - should run near each other, and set up the config files for the hostU's. Then the whole thing is very hard to kill indeed, assuming that the power outage doesn't kill the internet access.

  - So sell physical boxes that have independent internet (e.g. 2-5G), and an internal battery backup, and do the PXE hosting (and have enough storage to hold VM snapshots?). Very hard to kill, and can bring the rest of the cluster back online as fast as they can reboot.
