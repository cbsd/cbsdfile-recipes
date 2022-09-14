#!/bin/sh
# ./export.sh -e jail -j pgadmin4 -v 14.0
MYDIR=$( dirname `realpath $0` )

set -e
. ${MYDIR}/config.conf
. ${MYDIR}/func.subr
set +e

cmd_string=

jobname_file="upload-${jname}-${arch}-${ver}"
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

if [ ! -r /usr/jails/export/${jname}.img ]; then
	echo "no such /usr/jails/export/${jname}.img" >> ${log_file} 2>&1
	exit 1
fi

ssh_options="-oIdentityFile=${MYDIR}/.ssh/id_ed25519 -oStrictHostKeyChecking=no -oConnectTimeout=15 -oServerAliveInterval=10 -oUserKnownHostsFile=/dev/null -oPort=${UPLOAD_SSH_PORT}"
ssh_string="ssh -q ${ssh_options} ${UPLOAD_SSH_USER}@${UPLOAD_SSH_HOST}"
scp_string="scp ${ssh_options}"

echo "ssh_string: $ssh_string" >> ${log_file} 2>&1

sshtest=$( timeout 30 /usr/bin/lockf -s -t0 /tmp/cbsd-upload-${ver}.lock ${ssh_string} date )
ret=$?

if [ ${ret} -ne 0 ]; then
	echo "ssh failed: ${ssh_string}" >> ${log_file} 2>&1
	echo "${sshtest}" >> ${log_file} 2>&1
	exit ${ret}
fi

remote_dir="${UPLOAD_SSH_ROOT}${arch}/${arch}/${ver}/${jname}"

timeout 60 ${ssh_string} <<EOF
ls -la ${remote_dir}
echo "${remote_dir}"
test -d ${remote_dir} || mkdir -p ${remote_dir}
EOF


if [ ${ret} -ne 0 ]; then
	echo "ssh cd remote dir failed: ${remote_dir}" >> ${log_file} 2>&1
	echo "${sshtest}" >> ${log_file} 2>&1
	exit ${ret}
fi

if [ -r /usr/jails/formfile/${jname}.sqlite ]; then
	/usr/local/bin/sqlite3 /usr/jails/formfile/${jname}.sqlite "SELECT longdesc FROM system;" > /usr/jails/export/${jname}.desc
	is_forms=1
else
	if [ -r "${env_path}/descr" ]; then
		cat ${env_path}/descr > /usr/jails/export/${jname}.desc
	else
		echo "description not available" > /usr/jails/export/${jname}.desc
	fi
	is_forms=0
fi

${scp_string} /usr/jails/export/${jname}.img ${UPLOAD_SSH_USER}@${UPLOAD_SSH_HOST}:${remote_dir}/${jname}.img
ret=$?

if [ ${ret} -ne 0 ]; then
	echo "scp /usr/jails/export/${jname}.img failed" >> ${log_file} 2>&1
	echo "${scp_string} ${path}/base.txz ${UPLOAD_SSH_USER}@${UPLOAD_SSH_HOST}:${remote_dir}/${jname}.img" >> ${log_file} 2>&1
	exit ${ret}
fi

${scp_string} /usr/jails/export/${jname}.desc ${UPLOAD_SSH_USER}@${UPLOAD_SSH_HOST}:${remote_dir}/${jname}.desc
ret=$?

if [ ${ret} -ne 0 ]; then
	echo "scp /usr/jails/export/${jname}.img failed" >> ${log_file} 2>&1
	echo "${scp_string} ${path}/base.txz ${UPLOAD_SSH_USER}@${UPLOAD_SSH_HOST}:${remote_dir}/${jname}.img" >> ${log_file} 2>&1
	exit ${ret}
fi

if [ ${is_forms} -eq 1 ]; then
	vars=$( cbsd forms module=${jname} vars )
else
	vars=
fi

package_version=

if [ -r ${LOG_DIR}/package_version_${jname} ]; then
	package_version=$( cat ${LOG_DIR}/package_version_${jname} | awk '{printf $1}' )
fi


echo "/root/bin/calcimg.sh -j ${jname} -e ${emulator} -f ${ver} -a ${arch} -s 0 -v "${package_version}" -z '${vars}'" | tee -a ${log_file}

timeout 60 ${ssh_string} <<EOF
/root/bin/calcimg.sh -j ${jname} -e ${emulator} -f ${ver} -a ${arch} -s 0 -v "${package_version}" -z '${vars}'
EOF

ret=$?

if [ ${ret} -eq 0 ]; then
	rm -rf /usr/jails/export/${jname}.img
	cbsd ${destroy_cmd} ${jname}
fi

exit ${ret}
