#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="rtorrent"

path=$( cbsd jget mode=quiet jname=${jname} path 2>/dev/null )

if [ -S "${path}/tmp/rpc.socket" ]; then
	echo "RPC socket exist"
else
	echo "RPC socket not exist: ${path}/tmp/rpc.socket"
	exit 1
fi

exit 0
