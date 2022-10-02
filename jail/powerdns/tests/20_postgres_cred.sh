#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="powerdns"

res=$( cbsd jexec jname=${jname} <<EOF
su -m postgres -c /bin/sh << XEOF
/usr/local/bin/psql -tAc "SELECT 1 FROM pg_database WHERE datname='powerdns'"
XEOF
EOF
)

if [ "${res}" = "1" ]; then
	echo "Database powerdns exists"
	exit 0
else
	echo "Database powerdns not exist"
	exit 1
fi
