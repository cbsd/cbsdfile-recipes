#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	rtorrent UI: http://$ip4_addr

EOF
