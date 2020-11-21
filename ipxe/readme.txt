iPXE has a lot of options; it's possible even to boot it from a floppy or CD. To
build an image that's suitable for downloading over the network (with the TFTP 
protocol), you need to use the 'bin/undionly.kpxe' option.

Source: https://ipxe.org/howto/chainloading

For now, I'm keeping things simple. Run the build.ipxe.sh script, and experiment
with the ipxe-scripts until something works.

