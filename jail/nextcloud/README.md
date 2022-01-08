# for ZFS

1) create ZFS dataset for jail

```
zfs create -p -o compression=lz4 -o atime=off -o mountpoint=none zroot/storage
zfs create -p -o compression=lz4 -o atime=off -o mountpoint=none zroot/nextcloud/database
zfs create -p -o compression=lz4 -o atime=on -o mountpoint=none zroot/nextcloud/config
zfs create -p -o compression=lz4 -o atime=on -o mountpoint=none zroot/nextcloud/themes
zfs set primarycache=metadata zroot/nextcloud/database
zfs set recordsize=8k zroot/nextcloud/database
```


# for CBSD

2) Edit skel/* if necessary
3) Edit jails-system/fstab.local if necessary
4) Edit jails-system/stop.d/zfs-unmount.sh if necessary

5) Create jail: `env H_SSLCOUNTRY=FR H_SSLSTATE=Haute-Savoie H_SSLLOCATION=Sallanches H_SSLMAIL=user@domain.org cbsd up`


# Todo

- Why baserw=1 ? change data mountpoint into /usr/local/ ?
- External volumes optional
- Currently ZFS-only? Optional for UFS or iSCSI/NFS/..
- Certbot helper
- Switch (or create alternative template) to Puppet module
- Replica set ?

