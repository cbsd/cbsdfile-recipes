#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="qbittorrent"

pid=$( cbsd jexec jname=${jname} pgrep qbittorrent-nox 2>/dev/null | grep . | awk '{printf $1}' )

if [ -n "${pid}" ]; then
	echo "qbittorrent-nox process exist: ${pid}"
else
	echo "qbittorrent-nox process not exist"
	exit 1
fi

exit 0
