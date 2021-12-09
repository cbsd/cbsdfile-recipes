#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

pid=$( cbsd jexec jname=mysql pgrep mysqld 2>/dev/null | grep . | awk '{printf $1}' )

printf "Check mysqld process... " 2>&1

if [ -n "${pid}" ]; then
	echo "${pid}" 2>&1
	ret=0
else
	echo "failed" 2>&1
	ret=1
fi

exit ${ret}

