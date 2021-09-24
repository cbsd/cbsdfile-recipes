#!/bin/sh
# ./test.sh -e jail -j pgadmin4 -v 14.0
MYDIR=$( dirname `realpath $0` )

set -e
. ${MYDIR}/config.conf
. ${MYDIR}/func.subr
set +e

cmd_string=

jobname_file="tests-${jname}-${arch}-${ver}"
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

if [ ! -r "${env_path}/CBSDfile" ]; then
	echo "no such templates here: ${env_path}/CBSDfile" >> ${log_file} 2>&1
	exit 1
fi

cd ${MYDIR}

jid=$( cbsd ${status_cmd} ${jname} 2>/dev/null )
ret=$?

if [ ${ret} -ne 1 ]; then
	echo "no such jail: ${jname}" >> ${log_file} 2>&1
	exit 1
fi
if [ "${jid}" = "0" ]; then
	echo "jail not started: ${jname}" >> ${log_file} 2>&1
	exit 1
fi

if [ ! -d "${env_path}/tests" ]; then
	echo "template without tests, skipp: ${env_path}/tests" >> ${log_file} 2>&1
	exit 0
fi

tests_all=$( find ${env_path}/tests -type f -print 2>&1 | wc -l | awk '{printf $1}' )
echo "tests found: ${env_path}/tests: ${tests_all}" >> ${log_file} 2>&1

cur_tests=1

find ${env_path}/tests -type f -exec basename {} \;  | while read _test; do
	echo " --- ${cur_tests}/${tests_all}: ${_test} ---"
	${env_path}/tests/${_test} >> ${log_file} 2>&1
	ret=$?
	if [ ${ret} -ne 0 ]; then
		echo " >> ${_tests}: failed <<"
		exit 1
	fi
	echo
	cur_tests=$(( cur_tests + 1 ))
done

exit 0
