#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="memcached"

ip4_addr=$( cbsd jget mode=quiet jname=${jname} ip4_addr 2>/dev/null | grep . | awk '{printf $1}' )

if [ -z "${ip4_addr}" ]; then
	echo "unable to determine ip4_addr" 2>&1
	exit 1
fi

#echo "stats" | timeout 10 nc ${ip4_addr} 11211
timeout 10 nc -z ${ip4_addr} 11211
ret=$?
if [ ${ret} -ne 0 ]; then
	echo "memcached port not available ${ip4_addr}: 11211" 2>&1
	exit ${ret}
fi

exit 0
