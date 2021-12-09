#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

res=$( cbsd jexec jname=gitlab <<EOF
su -l git -c "cd /usr/local/www/gitlab-ce && rake gitlab:check RAILS_ENV=production"
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
