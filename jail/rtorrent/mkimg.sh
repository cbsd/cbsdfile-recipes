#!/bin/sh
# usage: <mkimg> -v 12.2
jname="rtorrent"
cbsd jremove ${jname} || true

# MAIN
while getopts "v:" opt; do
	case "${opt}" in
		v) ver="${OPTARG}" ;;
	esac
	shift $(($OPTIND - 1))
done

if [ -z "${ver}" ]; then
	echo "give me version, e.g.: -v 12.2"
	exit 1
fi
cbsd up ver=${ver}
cbsd forms module=rtorrent jname=${jname} debug_form=1
cbsd jstop ${jname}
find ~cbsd/jails-data/${jname}-data/tmp/ -type s -delete
cbsd jexport ${jname}

# flatsize/md5
