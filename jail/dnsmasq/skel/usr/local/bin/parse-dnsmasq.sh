#!/bin/sh

parse()
{
	local _res= _ip= _id=

	# Dec 28 02:57:52 pxe dnsmasq-dhcp[9900]: 2117556846 DHCPREQUEST(eth0) 172.16.0.196 00:a0:98:9d:a0:26
	eval $( echo ${line} | grep -E 'DHCPREQUEST\(eth0\) [0-9]+.[0-9]+.[0-9]+.[0-9]+ ' 2>/dev/null | awk '{printf "_id="$6"\n_ip="$8}' )

	if [ -n "${_id}" -a -n "${_ip}" ]; then
		echo "new DHCPREQUEST" > /var/log/tftp/${_ip}.status
		echo "${_id} ${_ip}" > /tmp/dhcpd.log2
		/usr/local/bin/dnsmasq_records
	fi

	return 0
}

while read line; do
	echo "Parsed: [${line}]" >> /tmp/dnsmasq.log
	parse
done

exit 0
