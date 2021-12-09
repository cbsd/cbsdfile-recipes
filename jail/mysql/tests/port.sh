#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

path=$( cbsd jget jname=mysql mode=quiet path 2>/dev/null )

printf "Check ${path}/tmp/mysql.sock socket..." 2>&1
if [ -S ${path}/tmp/mysql.sock ]; then
	echo "ok"
	ret=0
else
	echo "failed"
	ret=1
fi

exit ${ret}
