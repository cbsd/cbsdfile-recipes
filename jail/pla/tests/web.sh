#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="pla"

CURL_CMD=$( which curl )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

ip4_addr=$( cbsd jget jname=${jname} mode=quiet ip4_addr )

GREP_VAL="<input type='password'"

echo "Probing: http://${ip4_addr} ( filter cmd: ${GREP_VAL} )"
${CURL_CMD} --no-progress-meter -L http://${ip4_addr} | grep "${GREP_VAL}"
ret=$?

exit ${ret}
