#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="qbittorrent"

path=$( cbsd jget mode=quiet jname=${jname} path 2>/dev/null )

if [ -S "${path}/home/qbittorrent/conf/qBittorrent/config/ipc-socket" ]; then
	echo "IPC socket exist"
else
	echo "IPC socket not exist: ${path}/home/qbittorrent/conf/qBittorrent/config/ipc-socket"
	exit 1
fi

exit 0
