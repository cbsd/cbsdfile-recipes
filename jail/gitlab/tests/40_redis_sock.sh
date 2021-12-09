#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

res=$( cbsd jexec jname=gitlab file -S /var/run/redis/redis.sock 2>/dev/null )
ret=$?

if [ ${ret} -eq 0  ]; then
	echo "redis sock exist" 2>&1
else
	echo "redis sock not exist: /var/run/redis/redis.sock" 2>&1
	exit 1
fi

exit 0
