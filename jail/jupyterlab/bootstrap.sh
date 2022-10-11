#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	jupyterlab UI port: 8888  ( https://$ip4_addr:8888/lab )
	jupyterlab default pass : jupyter

EOF
