#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="roundcube"

CURL_CMD=$( which curl 2>/dev/null )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

# <form id="login-form" name="login-form" method="post" class="propform" action="./?_task=login">
GREP_VAL=""form.*method.*post.*login""

data=$( cbsd jget mode=quiet jname=${jname} data 2>/dev/null )
. ${data}/etc/rc.conf

max_retry=5
retry=0

if [ -n "${ipv4_first}" ]; then
	# check via IPv4
	for retry in $( jot ${max_retry} ); do
		printf "Check for login page http://${ipv4_first}:${roundcube_http_port}/ ( filter cmd: ${GREP_VAL} )...[${retry}/${max_retry}]" 2>&1
		${CURL_CMD} --no-progress-meter -L http://${ipv4_first}:${roundcube_http_port}/ | grep "${GREP_VAL}"
		ret=$?
		[ ${ret} -eq 0 ] && break
		retry=$(( retry + 1 ))
		sleep 1
	done
elif [ -n "${ipv6_first}" ]; then
	# check via IPv6
	for retry in $( jot ${max_retry} ); do
		printf "Check for login page http://[${ipv6_first}]:${roundcube_http_port}/ ( filter cmd: ${GREP_VAL} )...[${retry}/${max_retry}]" 2>&1
		${CURL_CMD} -6 --no-progress-meter -L http://[${ipv6_first}]:${roundcube_http_port}/ | grep "${GREP_VAL}"
		ret=$?
		[ ${ret} -eq 0 ] && break
		retry=$(( retry + 1 ))
		sleep 1
	done
else
	ipv4_first=$( /usr/local/bin/cbsd jget jname=${jname} mode=quiet ip4_addr )
	for retry in $( jot ${max_retry} ); do
		printf "Check for login page http://${ipv4_first}:${roundcube_http_port}/ ( filter cmd: ${GREP_VAL} )...[${retry}/${max_retry}]" 2>&1
		${CURL_CMD} --no-progress-meter -L http://${ipv4_first}:${roundcube_http_port}/ | grep "${GREP_VAL}"
		ret=$?
		[ ${ret} -eq 0 ] && break
		retry=$(( retry + 1 ))
		sleep 1
	done
fi

exit ${ret}
