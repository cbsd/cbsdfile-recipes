#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	GitLab URL          : http://${ip4_addr}
	GitLab root login   : root
	GitLab root passowrd: "yourpassword"

	Hint:
	Enable cluster mode if you expect to have a high load instance
	Ex. change amount of workers to 3 for 2GB RAM server
	Set the number of workers to at least the number of cores:

	vi /usr/local/www/gitlab/config/puma.rb

EOF
