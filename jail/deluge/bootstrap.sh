#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	qbittorrent UI: http://$ip4_addr:8080
	Default credentials:
	  user: admin
	  password: adminadmin

EOF
