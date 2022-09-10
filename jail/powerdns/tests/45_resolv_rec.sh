#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

REC_TEST="mytest.example.org"
[ -z "${jname}" ] && jname="powerdns"

if [ -n "${ipv4_first}" ]; then
	echo "drill @${ipv4_first}" 2>&1
elif [ -n "${ipv6_first}" ]; then
	echo "drill @${ipv6_first}" 2>&1
else
	ipv4_first=$( /usr/local/bin/cbsd jget jname=${jname} mode=quiet ip4_addr )
	echo "drill @${ipv4_first}" 2>&1
fi

test=$( drill @${ipv4_first} ${REC_TEST} 2>/dev/null | grep ^${REC_TEST} )

if [ -z "${test}" ]; then
	echo "can't resolv test records: ${REC_TEST}"
	exit 1
else
	echo "resolv passed: ${test}"
fi

exit 0
