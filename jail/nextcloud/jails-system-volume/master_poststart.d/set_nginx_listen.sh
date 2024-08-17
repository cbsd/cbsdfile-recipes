#!/bin/sh
# managed by Puppet

echo "set_nginx_listen hook: ipv4_first: ${ipv4_first}, ipv6_first: ${ipv6_first}" 1>&2

if [ -n "${ipv4_first}" -a -n "${ipv6_first}" ]; then
	# both stack enabled
	echo "set_nginx_listen: both stack enabled" 1>&2
	/usr/local/bin/cbsd jexec jname=${jname} <<EOF
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen80.conf
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen443.conf
echo "listen *:80;" >> /usr/local/etc/nginx/listen80.conf
echo "listen [::]:80;" >> /usr/local/etc/nginx/listen80.conf
echo "listen *:443 ssl;" >> /usr/local/etc/nginx/listen443.conf
echo "listen [::]:443 ssl;" >> /usr/local/etc/nginx/listen443.conf
echo "http2 on;" >> /usr/local/etc/nginx/listen443.conf
service nginx restart
EOF
elif [ -n "${ipv6_first}" -a -z "${ipv4_first}" ]; then
	# v6-only
	echo "set_nginx_listen: IPv6 only stack enabled" 1>&2
	/usr/local/bin/cbsd jexec <<EOF
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen80.conf
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen443.conf
echo "listen [::]:80;" >> /usr/local/etc/nginx/listen80.conf
echo "listen [::]:443 ssl;" >> /usr/local/etc/nginx/listen443.conf
echo "http2 on;" >> /usr/local/etc/nginx/listen443.conf
service nginx restart
EOF
elif [ -n "${ipv4_first}" -a -z "${ipv6_first}" ]; then
	# v4-only
	echo "set_nginx_listen: IPv4 only stack enabled" 1>&2
	/usr/local/bin/cbsd jexec <<EOF
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen80.conf
echo "# Managed by CBSDfile nextcloud template" > /usr/local/etc/nginx/listen443.conf
echo "listen *:80;" >> /usr/local/etc/nginx/listen80.conf
echo "listen *:443 ssl;" >> /usr/local/etc/nginx/listen443.conf
echo "http2 on;" >> /usr/local/etc/nginx/listen443.conf
service nginx restart
EOF
fi

exit ${ret}
