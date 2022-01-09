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

- Proper upgrade when external volume used: store password in volumes? skip db create, migration .., ... ?
- Why baserw=1 ? change data mountpoint into /usr/local/ ?
- External volumes optional
- Currently ZFS-only? Optional for UFS or iSCSI/NFS/..
- Certbot helper
- Switch (or create alternative template) to Puppet module
- Replica set ?


# Certbot addon, WIP:

    # add package:
    pkg add py38-certbot

    # nginx.conf ( symlink ? )
    ssl_certificate /usr/local/etc/letsencrypt/live/$H_NEXTCLOUD_FQDN/fullchain.pem;
    ssl_certificate_key /usr/local/etc/letsencrypt/live/$H_NEXTCLOUD_FQDN/privkey.pem;

    # cmd:
    certbot -n --agree-tos --email $H_SSLMAIL --webroot -w /usr/local/www/letsencrypt certonly -d $H_NEXTCLOUD_FQDN
