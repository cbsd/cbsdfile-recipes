#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="jupyterlab"

CURL_CMD=$( which curl 2>/dev/null )

if [ -z "${CURL_CMD}" ]; then
	echo "no such curl"
	exit 1
fi

ip4_addr=$( cbsd jget jname=${jname} mode=quiet ip4_addr 2>/dev/null )

GREP_VAL="A Jupyter Server is running."
printf "Check for login page https://%s:8888 ( filter cmd: %s )..." "${ip4_addr}" "${GREP_VAL}" 2>&1

${CURL_CMD} --no-progress-meter -L -k "https://${ip4_addr}:8888" | grep "${GREP_VAL}"
ret=$?

exit ${ret}
