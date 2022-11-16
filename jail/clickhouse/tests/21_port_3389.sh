#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="clickhouse"

NC_CMD=$( which nc )

if [ -z "${NC_CMD}" ]; then
	echo "no such nc"
	exit 1
fi

ip4_addr=$( cbsd jget jname=${jname} mode=quiet ip4_addr )

echo "Probing: ${ip4_addr}:8123" 2>&1
${NC_CMD} -z ${ip4_addr} 8123 2>&1
ret=$?

exit ${ret}
