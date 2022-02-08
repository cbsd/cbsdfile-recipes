#!/bin/sh
# Uncomment for ZFS external volumes:
/sbin/zfs set mountpoint=none zroot/gitlab/postgres
/sbin/zfs set mountpoint=none zroot/gitlab/repositories
