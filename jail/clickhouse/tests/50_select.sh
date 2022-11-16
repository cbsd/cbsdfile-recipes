#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1
[ -z "${jname}" ] && jname="clickhouse"

NC_CMD=$( which nc )

if [ -z "${NC_CMD}" ]; then
	echo "no such nc"
	exit 1
fi

ver=$( cbsd jexec jname=clickhouse <<EOF
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
2>/dev/null clickhouse-client <<XEOF
SELECT version()
XEOF
EOF
)
ret=$?

if [ ${ret} -ne 0 ]; then
	echo "clickhouse-client failed" 2>&1
	exit ${ret}
fi

if [ -z "${ver}" ]; then
	echo "clickhouse-client failed" 2>&1
	exit ${ret}
fi

echo "version: ${ver}" 2>&1

exit ${ret}
