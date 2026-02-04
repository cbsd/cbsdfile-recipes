#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="dnsmasq"
pid=$( cbsd jexec jname=${jname} pgrep dnsmasq 2>/dev/null | grep . | awk '{printf $1" "}' )

if [ -n "${pid}" ]; then
	echo "dnsmasq process exist: ${pid}"
else
	echo "dnsmasq process not exist"
	exit 1
fi

exit 0
