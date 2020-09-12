#!/bin/sh

jname="phpipam"

cbsd jremove ${jname} || true

cbsd up ver=12.1
cbsd forms module=phpipam jname=${jname} debug_form=1
cbsd jstop ${jname}
find ~cbsd/jails-data/${jname}-data/tmp/ -type s -delete
cbsd jexport ${jname}

# flatsize/md5
