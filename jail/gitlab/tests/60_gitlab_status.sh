#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="gitlab"

res=$( cbsd jexec jname=${jname} <<EOF
su -l git -c "cd /usr/local/www/gitlab && rake gitlab:check RAILS_ENV=production"
EOF
)

ret=$?

if [ ${ret} -eq 0 ]; then
	echo "Gitlab installed successfully!"
	exit 0
else
	echo "Gitlab check failed"
	exit 1
fi
