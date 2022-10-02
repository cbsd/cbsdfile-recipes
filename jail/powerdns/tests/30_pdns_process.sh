#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="powerdns"

pid=$( cbsd jexec jname=${jname} pgrep pdns_server 2>/dev/null | grep . | awk '{printf $1" "}' )

if [ -n "${pid}" ]; then
	echo "pdns_server process exist: ${pid}" 2>&1
else
	echo "pdns_server process not exist" 2>&1
	exit 1
fi

exit 0
