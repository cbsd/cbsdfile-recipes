#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="cbsdpuppetsrv"

signed=
signed=$( cbsd jexec jname=${jname} /usr/local/bin/puppetserver ca list --all 2>/dev/null | grep ${jname} | grep SHA256 | awk '{printf $1}' )

printf "Check signed ${jname} certificate... " 2>&1

if [ -n "${signed}" ]; then
	echo "${signed}" 2>&1
	ret=0
else
	echo "failed" 2>&1
	ret=1
fi

exit ${ret}
