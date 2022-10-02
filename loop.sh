#!/bin/sh
# ./loop.sh -e jail -j ALL -v 14.0
# -j can be specific jail in jail directory, e.g:
# ./loop.sh -e jail -j pgadmin4 -v 14.0
MYDIR=$( dirname `realpath $0` )

set -e
. ${MYDIR}/config.conf
. ${MYDIR}/func.subr
set +e

buildimg() {
	jname="${1}"

	jobname_conf="${jobname_file}.conf"
	jobname_result="/var/db/${jobname_file}-${emulator}-${jname}.result"

	last_success_build_time=
	last_success_build_duration=0

	if [ -r ${jobname_result} ]; then
		echo "read last result: ${jobname_result}" >> ${log_file} 2>&1
		. ${jobname_result}
	else
		touch ${jobname_result}
	fi

	st_time=$( /bin/date +%s )

	if [ -n "${last_success_build_time}" -a "${last_success_build_duration}" != "0" ]; then
		# 1 week = 604800 seconds
		build_time_week="604800"
		build_deadline_time=$(( st_time - build_time_week ))
		if [ ${last_success_build_time} -gt ${build_deadline_time} ]; then
			echo "last_success_build_time still in deadline range: skip ${jname}: ${last_success_build_time} > ${build_deadline_time}" >> ${log_file}
			return 0
		else
			echo "deadline, time to build: ${last_success_build_time} < ${build_deadline_time}" >> ${log_file}
		fi
	else
		echo "no last_success_build_time, time to build" >> ${log_file}
	fi

	echo "time to build: ${jname}" >> ${log_file}

	# up
	${MYDIR}/up.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}
	ret=$?

	if [ ${ret} -ne 0 ]; then
		echo "error: ${MYDIR}/up.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}" >> ${log_file}
		return ${ret}
	fi

	# test
	${MYDIR}/test.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}
	ret=$?

	if [ ${ret} -ne 0 ]; then
		echo "error: ${MYDIR}/test.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}" >> ${log_file}
		return ${ret}
	fi

	# export
	${MYDIR}/export.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}
	ret=$?

	if [ ${ret} -ne 0 ]; then
		echo "error: ${MYDIR}/export.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}" >> ${log_file}
		return ${ret}
	fi

	# upload
	${MYDIR}/upload.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}
	ret=$?

	if [ ${ret} -ne 0 ]; then
		echo "error: ${MYDIR}/upload.sh -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}" >> ${log_file}
		return ${ret}
	fi

	end_time=$( /bin/date +%s )
	diff_time=$(( end_time - st_time ))

	sysrc -qf ${jobname_result} last_success_build_time="${end_time}"
	sysrc -qf ${jobname_result} last_success_build_duration="${diff_time}"
	echo "build ${jname} image done in ${diff_time}" >> ${log_file}

	return 0
}

loop()
{
	if [ "${jname}" = "ALL" ]; then
		if [ ! -d ${MYDIR}/${emulator} ]; then
			echo "no such dir for emulator: ${MYDIR}/${emulator}"
			exit 1
		fi
		for jname in $( find ${MYDIR}/${emulator} -depth 1 -maxdepth 1 -type d -exec basename {} \; ); do
			[ "${jname}" = ".broken" ] && continue
			buildimg ${jname}
			/usr/local/bin/cbsd jremove ${jname}
		done
	else
		buildimg ${jname}
		/usr/local/bin/cbsd jremove ${jname}
	fi
}

jobname_file="loop-${arch}-${ver}"
log_file="${LOG_DIR}/${jobname_file}-${emulator}-${jname}-${log_date}.log"

if [ -n "${lock}" ]; then
	/usr/local/bin/cbsd portsup
	loop
	exit 0
else
	# recursive execite via lockf wrapper
	[ ! -d "${LOG_DIR}" ] && mkdir -p ${LOG_DIR}
	log_date=$( date "+%Y-%m-%d-%H-%M-%S" )
	log_file="${LOG_DIR}/${jobname_file}-${emulator}-${jname}-${log_date}.log"
	echo "get lock: ${GIANT_LOCK_FILE}" >> ${log_file}
	lockf -s -t10 ${GIANT_LOCK_FILE} ${MYDIR}/loop.sh -z lock -a ${arch} -e ${emulator} -j ${jname} -v ${ver} -d ${log_date}
fi

exit 0
