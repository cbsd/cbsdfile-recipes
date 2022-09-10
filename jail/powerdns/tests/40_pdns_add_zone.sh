#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="powerdns"

cbsd jexec jname=${jname} <<EOF
/root/powerdns/pdnsutil-add-domain.sh example.org
/root/powerdns/curl-create-record.sh
EOF

ret=$?
