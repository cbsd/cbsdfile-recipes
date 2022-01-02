# for ZFS

1) create ZFS dataset for jail

zfs create -p -o compression=lz4 -o atime=off -o mountpoint=none zroot/storage
zfs create -p -o compression=lz4 -o atime=off -o mountpoint=none zroot/nextcloud/database
zfs create -p -o compression=lz4 -o atime=on -o mountpoint=none zroot/nextcloud/config
zfs create -p -o compression=lz4 -o atime=on -o mountpoint=none zroot/nextcloud/themes

zfs set primarycache=metadata zroot/nextcloud/database

zfs set recordsize=8k zroot/nextcloud/database

env H_SSLCOUNTRY=FR H_SSLSTATE=Haute-Savoie H_SSLLOCATION=Sallanches H_SSLMAIL=qsdf@cbsd.org cbsd up

# for CBSD

2) Edit skel/* if necessary
3) Edit jails-system/fstab.local if necessary
4) Edit jails-system/stop.d/zfs-unmount.sh if necessary

5) env H_SSLCOUNTRY=FR H_SSLSTATE=Haute-Savoie H_SSLLOCATION=Sallanches H_SSLMAIL=user@domain.org cbsd up
