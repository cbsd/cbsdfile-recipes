#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
CURL_CMD=$( which curl 2>/dev/null )
[ -z "${jname}" ] && jname="nextcloud"

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

GREP_VAL="body-login"

if [ -n "${ipv4_first}" ]; then
	# check via IPv4
	printf "Check for login page https://${ipv4_first}/login ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k --no-progress-meter -L https://${ipv4_first}/login | grep "${GREP_VAL}"
	ret=$?
elif [ -n "${ipv6_first}" ]; then
	# check via IPv6
	printf "Check for login page https://[${ipv6_first}]/login ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k -6 --no-progress-meter -L https://[${ipv6_first}]/login | grep "${GREP_VAL}"
	ret=$?
else
	ipv4_first=$( /usr/local/bin/cbsd jget jname=${jname} mode=quiet ip4_addr )
	printf "Check for login page https://${ipv4_first}/login ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k --no-progress-meter -L https://${ipv4_first}/login | grep "${GREP_VAL}"
	ret=$?
fi

exit ${ret}
