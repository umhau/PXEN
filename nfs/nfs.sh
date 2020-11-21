

apk add nfs-utils                                                 # dependencies

rc-update add nfs                                          # start it on startup

rc-service nfs start                                              # start it now

mkdir -pv /srv/nfs/depot                               # create NFS serve folder

