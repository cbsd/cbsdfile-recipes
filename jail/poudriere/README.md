# for ZFS

1) create ZFS dataset for jail

zfs create zroot/poudr1-zfs-data

2) Edit skel/usr/local/etc/poudriere.conf if necessary
3) Edit jails-system/fstab.local if necessary
4) Edit jails-system/stop.d/zfs-unmount.sh if necessary

5) cbsd up

# this op can be moved into CBSDfile postcreate func
6) cbsd jexec jname=poudr1 poudriere jail -c -v 13.0-RELEASE -a amd64 -j mytest

# this op can be moved into CBSDfile postcreate func
7) cbsd jexec jname=poudr1 poudriere ports -c

# (optional) this op can be moved as 'update-ports.sh' hooks in jails-system/start.d
#   to update poudriere tree each time upon jail start
8) cbsd jexec jname=poudr1 poudriere ports -u

# build standalone package:
cbsd jexec jname=poudr1 poudriere testport -i -j mytest -o shells/bash

# OR create sample packages list in jail:

cbsd jlogin poudr1
cat > /root/pkg.list <<EOF
shells/bash
shells/zsh
EOF

poudriere bulk [-p default -j 130amd64 -z master-list] -f /root/pkg.list


10) See logs: http://<jailip>/

