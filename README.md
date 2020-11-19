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

## how to use

1. A boot image to be served by the TFTP server is required. 

```
cd ipxe
bash build.ipxe_image.sh
```

## stayin' alive

Free software, paid consulting.