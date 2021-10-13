#!/bin/sh

[ -z "${ip4_addr}" ] && ip4_addr="<jail ip>"

cat <<EOF


  Sambashare jail installed with defined a RW share that is
  accessible without authentication !

  To complete CBSD Samba jail (puppet-based) please use 'samba4' jail.

  Usage:

  smb://$ip4_addr

or:

  \\$ip4_addr

EOF
