There's several tools here. 

dhcp.sh is used to figure out the IP addresses of extant DHCP servers. So far,
it only returns the first discovered DHCP server - if there's multiple networks
connected to the host machine, the script will fail.

(Eventually, be able to serve PXE boot images on all discovered networks - this 
shouldn't be too hard, since I can specify the server IP in the config and can
probably run multiple proxy DHCP servers on the same host, one per network. 
Annoying to test, though.)

proxyDHCPd is used to actually run the PXE server.  Don't bother installing it;
the installer doesn't work. BTW, that code was full of typos. 

To install (if you feel like bugfixing):

  sudo python2 setup.py install

Otherwise, just run it from the git directory.