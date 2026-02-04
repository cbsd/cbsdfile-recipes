#!/bin/sh

parse()
{
	local _res= _ip= _id=
	[ ! -d /var/log/tftp ] && mkdir -p /var/log/tftp

	# Dec 28 03:17:26 pxe dnsmasq-tftp[9900]: sent /usr/local/srv/ltsp/ltsp/ltsp.ipxe to 172.16.0.196
	eval $( echo ${line} | grep -E '(: sent )*(to )' 2>/dev/null | awk '{printf "_file="$7"\n_ip="$9}' )

	if [ -n "${_file}" -a -n "${_ip}" ]; then
		echo "sent ${_file}" > /var/log/tftp/${_ip}.action
		echo "${_file} ${_ip}" > /tmp/tftp.log2
		/usr/local/bin/dnsmasq_records html
		return 0
	fi

	# Dec 28 03:28:35 pxe dnsmasq-tftp[9900]: file /usr/local/srv/ltsp/FreeBSD-14.2/boot/loader.efi not found for 172.16.0.196
	eval $( echo ${line} | grep -E '(: file )*(not found for)' 2>/dev/null | awk '{printf "_file="$7"\n_ip="$11}' )
	if [ -n "${_file}" -a -n "${_ip}" ]; then
		echo "file not found ${_file}" > /var/log/tftp/${_ip}.action
		echo "${_file} ${_ip}" > /tmp/tftp.log2
		/usr/local/bin/dnsmasq_records html
		return 0
	fi
}

while read line; do
	echo "Parsed: [${line}]" >> /tmp/tftp.log
	parse
done

exit 0
