#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

pid=$( cbsd jexec jname=gitlab pgrep nginx 2>/dev/null | grep . | awk '{printf $1}' )

if [ -n "${pid}" ]; then
	echo "nginx process exist: ${pid}" 2>&1
else
	echo "nginx process not exist" 2>&1
	exit 1
fi

exit 0
