#!/bin/sh
# ./export.sh -e jail -j pgadmin4 -v `sysctl -n kern.osrelease | cut -d - -f 1`
MYDIR=$( dirname `realpath $0` )

set -e
. ${MYDIR}/config.conf
. ${MYDIR}/func.subr
set +e

cmd_string=

jobname_file="export-${jname}-${arch}-${ver}"
log_file="${LOG_DIR}/${jobname_file}-${log_date}.log"

if [ "${myarch}" != "${arch}" ]; then
	echo "not native arch: ${myarch}/${arch}" >> ${log_file} 2>&1
	exit 1
	if [ -z "${target_arch}" ]; then
		echo "empty target_arch" >> ${log_file} 2>&1
		exit 1
	fi
fi

env_path="${MYDIR}/${emulator}/${jname}"

cd ${MYDIR}

[ -r /usr/jails/export/${jname}.img ] && rm -f /usr/jails/export/${jname}.img
cbsd ${stop_cmd} ${jname} >> ${log_file} 2>&1 || true
cbsd ${export_cmd} ${jname} >> ${log_file} 2>&1

if [ ! -r /usr/jails/export/${jname}.img ]; then
	echo "no such image: /usr/jails/export/${jname}.img" >> ${log_file} 2>&1
	exit 1
fi

cbsd ${destroy_cmd} pgadmin4 >> ${log_file} 2>&1 || true

exit 0
