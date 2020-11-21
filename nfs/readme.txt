Notes.

The NFS export does not currently need to contain anything, unless you wish to 
use it to serve apks, in which case ensure that a file ".boot_repository" is 
created in the directory containing architecture subdirectories and remove 
alpine_repo from the kernel arguments. The repository will be autodetected by
searching for ".boot_repository". Eventually Alpine will be able to load kernel 
modules from this export. 