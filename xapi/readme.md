# installing the XAPI

xapi is a toolstack that sits on top of xen. xen is the hypervisor technology.
xapi is what xcp-ng center and xen orchestra use to control their hypervisors. 

xapi is hard to install.

## first installation attempt. notes.

### Step 1: get opam installed and working. 

- Add the community repository in alpine

nano /etc/apk/repositories

Should look like this: 

    #/media/cdrom/apks
    http://dl-cdn.alpinelinux.org/alpine/v3.12/main
    http://dl-cdn.alpinelinux.org/alpine/v3.12/community
    #http://dl-cdn.alpinelinux.org/alpine/edge/main
    #http://dl-cdn.alpinelinux.org/alpine/edge/community
    #http://dl-cdn.alpinelinux.org/alpine/edge/testing

Then install opam:

apk add opam

### Step 2: build xapi packages using opam.

https://github.com/xapi-project/xs-opam

Clone the repo, then notice that inside packages/xs all the folders contain a 
single opam file. I think that file can be fed to opam, to install that package. 

### Step 3: maybe then install xapi.

https://github.com/xapi-project/xen-api

Notice in this file that the packages in the xs-opam repo are required as 
dependencies. I think that means the xen-api repo is the one to aim for, being 
the actual xapi repo. 

https://github.com/xapi-project/xen-api/blob/master/xapi.opam

Since the readme recommends using the xs-opam github repository as a package 
repository, it may be that I add it to opam as a repo using

    opam repo add xs-opam https://github.com/xapi-project/xs-opam.git

And then go back to the xen-api repo to do the actual installation. That would 
mean that I can avoid installing the dependencies by hand.
