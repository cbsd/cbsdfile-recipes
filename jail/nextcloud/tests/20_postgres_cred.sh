#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

export NOCOLOR=1

res=$( env NOCOLOR=1 cbsd jexec jname=nextcloud <<EOF
/usr/local/bin/psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='nextcloud'"
EOF
)

if [ "${res}" = "1" ]; then
	echo "Database nextcloud exist"
	exit 0
else
	echo "Database nextcloud not exist"
	exit 1
fi
