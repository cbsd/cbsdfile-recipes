#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

CURL_CMD=$( which curl 2>/dev/null )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

ip4_addr=$( cbsd jget jname=pgadmin4 mode=quiet ip4_addr 2>/dev/null )

GREP_VAL="submit.*Login"
printf "Check for login page http://${ip4_addr}:5050 ( filter cmd: ${GREP_VAL} )..." 2>&1

${CURL_CMD} --no-progress-meter -L http://${ip4_addr}:5050 | grep "${GREP_VAL}"
ret=$?

exit ${ret}
