#!/bin/sh
timeout 30 /usr/local/bin/cbsd service jname=rabbitmq mode=action rabbitmq status
ret=$?
exit ${ret}
