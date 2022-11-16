#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="clickhouse"
pid=$( cbsd jexec jname=${jname} pgrep clickhouse 2>/dev/null | grep . | awk '{printf $1" "}' )

if [ -n "${pid}" ]; then
	echo "clickhouse process exist: ${pid}"
else
	echo "clickhouse process not exist"
	exit 1
fi

exit 0
