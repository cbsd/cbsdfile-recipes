#!/bin/sh
export NOCOLOR=1
[ -z "${jname}" ] && jname="rabbitmq"

timeout 30 /usr/local/bin/cbsd service jname=${jname} mode=action rabbitmq status
ret=$?
exit ${ret}
