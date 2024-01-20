#!/bin/sh
#
# PROVIDE: pgadmin4
# REQUIRE: DAEMON
# KEYWORD: shutdown
#
# pgadmin4_enable="YES"
#

. /etc/rc.subr

name=pgadmin4
rcvar=pgadmin4_enable
pidfile="/var/run/${name}.pid"
daemon_pidfile="/var/run/${name}-daemon.pid"
logdir="/var/log/${name}"
logfile="${logdir}/${name}.log"
extra_commands="reload"
command="/usr/local/bin/python%%PY_VERSION%%"

load_rc_config $name

: ${pgadmin4_enable="NO"}

start_cmd=${name}_start
stop_cmd=${name}_stop
status_cmd="status"
reload_cmd="reload"

pgadmin4_start()
{
	export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
	export PGADMIN_SETUP_EMAIL="root@example.org"
	export PGADMIN_SETUP_PASSWORD="root"
	export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

	[ ! -d ${logdir} ] && mkdir -p ${logdir}
	touch ${logfile}

	/usr/sbin/daemon -f -R5 -p ${pidfile} -P ${daemon_pidfile} -o ${logfile} ${command} /usr/local/lib/python%%PY_VERSION%%/site-packages/pgadmin4/pgAdmin4.py
}

pgadmin4_stop()
{
	export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
	if [ -f "${daemon_pidfile}" ]; then
		pids=$( pgrep -F ${daemon_pidfile} 2>&1 )
		_err=$?
		[ ${_err} -eq  0 ] && kill -9 ${pids} && /bin/rm -f ${daemon_pidfile}
	fi
	if [ -f "${pidfile}" ]; then
		pids=$( pgrep -F ${pidfile} 2>&1 )
		_err=$?
		[ ${_err} -eq  0 ] && kill -9 ${pids} && /bin/rm -f ${pidfile}
	fi
}

reload()
{
	stop
	start
}

status()
{
	if [ -f "${pidfile}" ]; then
		pids=$( pgrep -F ${pidfile} 2>&1 )
		_err=$?
		if [ ${_err} -eq  0 ]; then
			echo "${name} is running as pid ${pids}"
			exit 0
		else
			echo "wrong pid: ${pids}"
			exit 1
		fi
	else
		echo "no pidfile $pidfile"
		exit 1
	fi
}

run_rc_command "$1"
