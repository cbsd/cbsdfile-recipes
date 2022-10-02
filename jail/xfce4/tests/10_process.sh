#!/bin/sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export NOCOLOR=1

[ -z "${jname}" ] && jname="xfce4"
pid=$( cbsd jexec jname=${jname} pgrep xrdp 2>/dev/null | grep . | awk '{printf $1" "}' )

if [ -n "${pid}" ]; then
	echo "xrdp process exist: ${pid}"
else
	echo "xrdp process not exist"
	exit 1
fi

pid=$( cbsd jexec jname=${jname} pgrep xrdp-sesman 2>/dev/null | grep . | awk '{printf $1" "}' )

if [ -n "${pid}" ]; then
	echo "xrdp-sesman process exist: ${pid}"
else
	echo "xrdp-sesman process not exist"
	exit 1
fi

exit 0
