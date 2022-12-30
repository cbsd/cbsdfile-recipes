#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="redmine"

pid=$( cbsd jexec jname=${jname} pgrep mysqld 2>/dev/null | grep . | awk '{printf $1" "}' )

printf "Check mysql process... " 2>&1

if [ -n "${pid}" ]; then
	echo "${pid}" 2>&1
	ret=0
else
	echo "failed" 2>&1
	ret=1
fi

exit ${ret}
