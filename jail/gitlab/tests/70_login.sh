#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

CURL_CMD=$( which curl 2>/dev/null )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

GREP_VAL=""form.*action.*post""

# SSL?
exit 0

if [ -n "${ipv4_first}" ]; then
	# check via IPv4
	printf "Check for login page http://${ipv4_first}/users/sign_in ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} --no-progress-meter -L http://${ipv4_first}/users/sign_in | grep "${GREP_VAL}"
	ret=$?
elif [ -n "${ipv6_first}" ]; then
	# check via IPv6
	printf "Check for login page http://[${ipv6_first}]/users/sign_in ( filter cmd: ${GREP_VAL} )..." 2>&1
	${CURL_CMD} -6 --no-progress-meter -L http://[${ipv6_first}]/users/sign_in | grep "${GREP_VAL}"
else
	echo "Unable to determine ipv4_first/ipv6_first facts"
	ret=1
fi

exit ${ret}
