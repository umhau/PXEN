# installing the XAPI

xapi is a toolstack that sits on top of xen. xen is the hypervisor technology.
xapi is what xcp-ng center and xen orchestra use to control their hypervisors. 

xapi is hard to install.

## todo

I suspect that the original build environment uses ocaml 4.02.3, but there's some
inconsistencies in the dependency graph - I can't find a scenario that actually 
fits all the pieces involved.

Next step, `bash dependencies.sh` and try to sort out a way to get everything compiling.

Alternately: see if I can build docker, and then pull the pieces out of there. Docker uses Alpine, right?

## installation

```
bash dependencies.sh
bash xapi.sh
```
## installing old version of ocaml


  <ikke> So you read this? https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package
  <QDX45> Just spent a couple hours on that page.
  <ikke> Is there anything specific that is unclear?
  <ikke> the APKBUILD is a file that describes how to build a certain project and how to package it
  <QDX45> I follow the instructions, but I get errors I don't understand.
  <QDX45> Is the APKBUILD supposed to be in a directory by itself?
  <QDX45> When I run abuild -r, what directory should I be in, and what else should be in that directory?
  <QDX45> Can I download the APKBUILD you linked, put it in an empty directory, and use abuild -r to create the package?
  <ikke> easiest is to clone aports
  <QDX45> Yeah, did that too
  <ikke> then you navigate to community/ocaml in that dir
  <ikke> in that repo
  * Disconnected ()

  * Loaded log from Wed Nov 25 13:59:16 2020

  * Now talking on #alpine-linux
  * Topic for #alpine-linux is: Alpine Linux, the secure lightweight distro | release 3.12.1 is out! | slow channel, ask your question and wait for a response. :)
  * Topic for #alpine-linux set by ncopa!~ncopa@alpine/ncopa (Wed Oct 21 06:07:58 2020)
  <QDX45> well that was annoying. Pulled up the github repo for aports and crashed my computer.
  <QDX45> Sorry for disappearing.
  <QDX45> What do I do after navigating to community/ocaml in the aports git?
  <ikke> first try to build that version with abuild -r
  <hechos> anyone get adb server running from android-tools?
  <caskd> you need to run adb start-server as root for some reason
  <QDX45> Thanks
  <QDX45> Seems to be building without issue so far
  <hechos> caskd: running as doas and get could not install *smartsocket* listener: Address not available
  <ikke> caskd: I think you need a udev rule to be able to run it as non-root
  <caskd> yeah
  <hechos> what example for udev rule, ,,,
  <ikke> https://wiki.archlinux.org/index.php/Android_Debug_Bridge#Adding_udev_rules
  <QDX45> So once this test run of abuild -r finishes, can I just change the version number in APKBUILD, and it'll download the correct source version from the ocaml repo?
  <codebam> After I use lbu revert do I need to commit that or do I just reboot?
  <ikke> QDX45: after you change the version number, you need to run abuild checksum
  <QDX45> oh, ok. 
  <QDX45> then abuild -r?
  <ikke> yes
  <QDX45> And, does abuild -r generate the .apk package?
  <ikke> yes
  <QDX45> awesome, thank you. That makes a lot more sense.
  <QDX45> heh. failed b/c no space left. I'll keep working on it. Thanks for your help!
  <ikke> yw
  <ikke> the package is installed in ~/package/community/<arch>
