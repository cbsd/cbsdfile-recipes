#!/bin/sh
/sbin/zfs set mountpoint=none zroot/storage
/sbin/zfs set mountpoint=none zroot/nextcloud/database
/sbin/zfs set mountpoint=none zroot/nextcloud/config
/sbin/zfs set mountpoint=none zroot/nextcloud/themes
