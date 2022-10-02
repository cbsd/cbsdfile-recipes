#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	pgadmin4 UI port: 5050  ( http://$ip4_addr:5050 )
	pgadmin4 default email: root@localhost
	pgadmin4 default pass : admin

EOF
