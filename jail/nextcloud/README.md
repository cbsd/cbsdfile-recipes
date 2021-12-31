# for ZFS

1) create ZFS dataset for jail

zfs create -p -o compression=lz4 -o atime=off zroot/storage
zfs create -p -o compression=lz4 -o atime=off zroot/nextcloud/database
zfs create -p -o compression=lz4 -o atime=on zroot/nextcloud/config
zfs create -p -o compression=lz4 -o atime=on zroot/nextcloud/themes

zfs set primarycache=metadata zroot/nextcloud/database

zfs set recordsize=8k zroot/nextcloud/database

2) Edit skel/* if necessary
3) Edit jails-system/fstab.local if necessary
4) Edit jails-system/stop.d/zfs-unmount.sh if necessary

5) cbsd up
