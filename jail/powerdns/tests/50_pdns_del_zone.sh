#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="powerdns"

cbsd jexec jname=${jname} <<EOF
/root/powerdns/pdnsutil-delete-domains.sh example.org
EOF

ret=$?
