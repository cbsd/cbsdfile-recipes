#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

pid=$( cbsd jexec jname=rtorrent pgrep rtorrent 2>/dev/null | grep . | awk '{printf $1}' )

if [ -n "${pid}" ]; then
	echo "rtorrent process exist: ${pid}"
else
	echo "rtorrent process not exist"
	exit 1
fi

exit 0
