#!/bin/sh
# ./up.sh -e jail -j pgadmin4 -v 14.0
MYDIR=$( dirname `realpath $0` )

set -e
. ${MYDIR}/config.conf
. ${MYDIR}/func.subr
set +e

cmd_string=

jobname_file="image-${jname}-${arch}-${ver}"
log_file="${LOG_DIR}/${jobname_file}-${log_date}.log"

if [ "${myarch}" != "${arch}" ]; then
	echo "not native arch: ${myarch}/${arch}" >> ${log_file} 2>&1
	exit 1
	if [ -z "${target_arch}" ]; then
		echo "empty target_arch" >> ${log_file} 2>&1
		exit 1
	fi
fi

cd ${MYDIR}
env_path="${MYDIR}/${emulator}/${jname}"
cbsd ${destroy_cmd} ${jname} > /dev/null 2>&1 || true

if [ ! -r "${env_path}/CBSDfile" ]; then
	echo "no such templates here: ${env_path}/CBSDfile" >> ${log_file} 2>&1
	exit 1
fi

echo "template found: ${env_path}/CBSDfile" >> ${log_file} 2>&1

# CBSDFile
cd ${env_path}
cmd_string="cbsd up ver=${ver}"
${cmd_string} >> ${log_file} 2>&1
ret=$?

cd ${MYDIR}

if [ ${ret} -ne 0 ]; then
	echo "up failed: ${env_path}/CBSDfile" >> ${log_file} 2>&1
	exit ${ret}
fi

jid=$( cbsd ${status_cmd} ${jname} 2>/dev/null )
ret=$?

if [ ${ret} -ne 1 ]; then
	echo "no such jail: ${jname}" >> ${log_file} 2>&1
	exit 1
fi
if [ "${jid}" = "0" ]; then
	cbsd ${start_cmd} ${jname} >> ${log_file} 2>&1
	sleep 10
	jid=$( cbsd ${status_cmd} ${jname} 2>/dev/null )
	if [ "${jid}" = "0" ]; then
		echo "jail not started: ${jname}" >> ${log_file} 2>&1
		exit 1
	fi
fi

exit 0
