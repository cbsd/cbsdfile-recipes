#!/bin/sh

parse()
{
	local _res= _ip= _id=
	[ ! -d /var/log/tftp ] && mkdir -p /var/log/tftp

	# Dec 28 02:57:52 pxe dnsmasq-dhcp[9900]: 2117556846 DHCPREQUEST(eth0) 172.16.0.196 00:a0:98:9d:a0:26
	eval $( echo ${line} | grep -E 'DHCPREQUEST\(eth0\) [0-9]+.[0-9]+.[0-9]+.[0-9]+ ' 2>/dev/null | awk '{printf "_id="$6"\n_ip="$8}' )

	if [ -n "${_id}" -a -n "${_ip}" ]; then
		echo "new DHCPREQUEST" > /var/log/tftp/${_ip}.status
		echo "${_id} ${_ip}" > /tmp/dhcp.log2
		/usr/local/bin/dnsmasq_records html
	else
		# Jan  2 08:45:23 pxetest dnsmasq-dhcp[79655]: 286620046 dhcpISCOVER(eth0) 00:a0:98:d6:f6:9d no address available
		eval $( echo ${line} | grep 'no address available' 2>/dev/null | awk '{printf "_id="$6"\n_ip="$8}' )

		if [ -n "${_id}" -a -n "${_ip}" ]; then
			_ts=$( date +%s )
			_mac="${_ip}"
			_ip="0.0.0.0"
			echo "${_ts} ${_id} ${_mac}" > /tmp/dhcp.log2
			echo "no address available" > /var/log/tftp/${_mac}.status
			echo "${_id} ${_mac}" > /var/db/dnsmasq/dnsmasq.leases.err
			/usr/local/bin/dnsmasq_records html
		fi
	fi

	return 0
}

while read line; do
	echo "Parsed: [${line}]" >> /tmp/dhcp.log
	parse
done

exit 0
