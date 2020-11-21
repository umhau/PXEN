sources

https://ixnfo.com/en/install-and-configure-tftpd-hpa.html
http://www.chschneider.eu/linux/server/tftpd-hpa.shtml

steps

The goal is for this to run on Alpine Linux. Hence the 'apk' package manager.

files managed / created by tftp-hpa:

/etc/conf.d/in.tftpd
/etc/init.d/in.tftpd
/usr/bin/tftp
/usr/sbin/in.tftpd

src: https://pkgs.alpinelinux.org/contents?branch=edge&name=tftp-hpa&arch=x86_64&repo=main

From reading that first file, it looks like the expected TFTP file serve 
location is '/var/tftpboot/'. 

starting tftpd

to start it manually: rc-service in.tftpd start

to start it on startup: rc-update add in.tftpd default

