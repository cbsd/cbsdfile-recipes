#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
CURL_CMD=$( which curl 2>/dev/null )
[ -z "${jname}" ] && jname="cbsdmirror"

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

GREP_VAL="initialization"

if [ -n "${ipv4_first}" ]; then
	# check via IPv4
	printf "Check for login page http://${ipv4_first}/ ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k --no-progress-meter -L http://${ipv4_first}/ | grep "${GREP_VAL}"
	ret=$?
elif [ -n "${ipv6_first}" ]; then
	# check via IPv6
	printf "Check for login page http://[${ipv6_first}]/ ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k -6 --no-progress-meter -L http://[${ipv6_first}]/ | grep "${GREP_VAL}"
	ret=$?
else
	ipv4_first=$( /usr/local/bin/cbsd jget jname=${jname} mode=quiet ip4_addr )
	printf "Check for login page http://${ipv4_first}/ ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -k --no-progress-meter -L http://${ipv4_first}/ | grep "${GREP_VAL}"
	ret=$?
fi

exit ${ret}
