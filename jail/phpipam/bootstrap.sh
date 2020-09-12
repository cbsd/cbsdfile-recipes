#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF

	Default user/password is: Admin/ipamadmin
	${jname} url          : http://${ip_addr}

EOF
