#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	HTTP port: 80  ( http://$ip4_addr )

EOF
