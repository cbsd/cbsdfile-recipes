#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

CURL_CMD=$( which curl )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

ip4_addr=$( cbsd jget jname=phpipam mode=quiet ip4_addr )
echo "Probing: http://${ip4_addr}"
${CURL_CMD} --no-progress-meter -L http://${ip4_addr} | grep 'Please login'
ret=$?

exit ${ret}
