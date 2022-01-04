#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
NC_CMD=$( which nc )

if [ -z "${NC_CMD}" ]; then
	echo "no such nc"
	exit 1
fi

# Multiple IP? v6?
ip4_addr=$( cbsd jget jname=nextcloud mode=quiet ip4_addr )

for port in 80 443; do
	echo "Probing: ${ip4_addr}:${port}" 2>&1
	timeout 30 ${NC_CMD} -z ${ip4_addr} ${port} 2>&1
	ret=$?
	[ ${ret} -ne 0 ] && exit ${ret}
done

exit 0
