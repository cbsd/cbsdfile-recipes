#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="rabbitmq"

CURL_CMD=$( which curl 2>/dev/null )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

ip4_addr=$( cbsd jget jname=${jname} mode=quiet ip4_addr 2>/dev/null )
GREP_VAL="start_app_login"

case "${ip4_addr}" in
	*\.*\.*\.*)
		printf "Check for login page http://${ip4_addr}:15672 ( filter cmd: ${GREP_VAL} )..." 2>&1
		${CURL_CMD} --no-progress-meter -L http://${ip4_addr}:15672 | grep "${GREP_VAL}"
		ret=$?
		;;
	*:*)
		printf "Check for login page http://[${ip4_addr}]:15672 ( filter cmd: ${GREP_VAL} )..." 2>&1
		${CURL_CMD} -6 --no-progress-meter -L http://[${ip4_addr}]:15672 | grep "${GREP_VAL}"
		ret=$?
		;;
esac

exit ${ret}
