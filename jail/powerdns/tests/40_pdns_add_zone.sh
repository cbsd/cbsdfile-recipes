#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="powerdns"

cbsd jexec jname=${jname} <<EOF
/root/powerdns/pdnsutil-add-domain.sh example.org > /dev/null 2>&1
sleep 2
/root/powerdns/curl-create-record.sh > /tmp/curl-create-record.log 2>&1
sleep 2
service pdns restart
sleep 2
EOF

ret=$?
