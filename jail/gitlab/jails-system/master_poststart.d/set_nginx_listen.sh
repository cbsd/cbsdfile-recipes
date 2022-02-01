#!/bin/sh
# managed by CBSDfile

echo "set_nginx_listen hook: ipv4_first: ${ipv4_first}, ipv6_first: ${ipv6_first}" 1>&2

. ${data}/etc/rc.conf

[ -z "${gitlab_http_port}" ] && gitlab_http_port="80"
[ -z "${gitlab_https_port}" ] && gitlab_https_port="0"


if [ -n "${ipv4_first}" -a -n "${ipv6_first}" ]; then
	# both stack enabled
	echo "set_nginx_listen: both stack enabled" 1>&2
	/usr/local/bin/cbsd jexec jname=${jname} <<EOF
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-http.conf
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-https.conf
echo "listen *:${gitlab_http_port};" >> /usr/local/etc/nginx/listen-http.conf
echo "listen [::]:${gitlab_http_port};" >> /usr/local/etc/nginx/listen-http.conf

if [ "${gitlab_https_port}" != "0" ]; then
	echo "listen *:${gitlab_https_port} ssl http2;" >> /usr/local/etc/nginx/listen-https.conf
	echo "listen [::]:${gitlab_https_port} ssl http2;" >> /usr/local/etc/nginx/listen-https.conf
fi

service nginx restart
EOF
elif [ -n "${ipv6_first}" -a -z "${ipv4_first}" ]; then
	# v6-only
	echo "set_nginx_listen: IPv6 only stack enabled" 1>&2
	/usr/local/bin/cbsd jexec <<EOF
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-http.conf
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-https.conf
if [ "${gitlab_https_port}" != "0" ]; then
	echo "listen [::]:${gitlab_http_port};" >> /usr/local/etc/nginx/listen-http.conf
fi
echo "listen [::]:${gitlab_https_port} ssl http2;" >> /usr/local/etc/nginx/listen-https.conf

service nginx restart
EOF
elif [ -n "${ipv4_first}" -a -z "${ipv6_first}" ]; then
	# v4-only
	echo "set_nginx_listen: IPv4 only stack enabled" 1>&2
	/usr/local/bin/cbsd jexec <<EOF
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-http.conf
echo "# Managed by CBSDfile gitlab template" > /usr/local/etc/nginx/listen-https.conf
echo "listen *:${gitlab_http_port};" >> /usr/local/etc/nginx/listen-http.conf
if [ "${gitlab_https_port}" != "0" ]; then
	echo "listen *:${gitlab_https_port} ssl http2;" >> /usr/local/etc/nginx/listen-https.conf
fi
service nginx restart
EOF
fi

exit ${ret}
