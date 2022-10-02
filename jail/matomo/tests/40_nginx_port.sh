#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

NC_CMD=$( which nc )

[ -z "${jname}" ] && jname="matomo"

if [ -z "${NC_CMD}" ]; then
	echo "no such nc"
	exit 1
fi

if [ -n "${ipv4_first}" ]; then
	# check via IPv4
	echo "Probing: ${ipv4_first}:80" 2>&1
	${NC_CMD} -z ${ipv4_first} 80 2>&1
	ret=$?
elif [ -n "${ipv6_first}" ]; then
	# check via IPv6
	echo "Probing: [${ipv6_first}]:80" 2>&1
	${NC_CMD} -6 -z [${ipv6_first}] 80 2>&1
	ret=$?
else
	ipv4_first=$( /usr/local/bin/cbsd jget jname=${jname} mode=quiet ip4_addr )
	echo "Probing: ${ipv4_first}:80" 2>&1
	${NC_CMD} -z ${ipv4_first} 80 2>&1
	ret=$?
fi

echo "RET: ${ret}"

exit ${ret}
