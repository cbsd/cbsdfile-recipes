#!/bin/sh

jname="rtorrent"

cbsd jremove ${jname} || true

cbsd up ver=12.2
#cbsd up ver=13
cbsd forms module=rtorrent jname=${jname} debug_form=1
cbsd jstop ${jname}
find ~cbsd/jails-data/${jname}-data/tmp/ -type s -delete
cbsd jexport ${jname}

# flatsize/md5
