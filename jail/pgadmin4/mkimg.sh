#!/bin/sh
# usage: <mkimg> -v 12.2
jname="pgadmin4"
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
mkdir -p ~cbsd/jails-system/${jname}/bin
cp -a bootstrap.sh ~cbsd/jails-system/${jname}/bin/
cbsd jstop ${jname}
cbsd jexport ${jname}

# flatsize/md5
