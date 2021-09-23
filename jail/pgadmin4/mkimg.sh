#!/bin/sh
# For CBSD dl.bsdstore.ru host
dst_root="/usr/jails/jails-data/nginx-data/usr/local/www/dl.bsdstore.ru/img/amd64/amd64"
index="/usr/jails/jails-data/nginx-data/usr/local/www/www.bsdstore.ru/imgls.v2"

jname="pgadmin4"
ver="${1}"
[ -z "${ver}" ] && exit 1

cbsd jstop ${jname}
cbsd jexport ${jname}

if [ ! -r /usr/jails/export/${jname}.img ]; then
	echo "no such image"
	exit 1
fi

dl_dir="${dst_root}/${ver}/${jname}"
echo "dl_dir: ${dl_dir}"

[ ! -d ${dl_dir} ] && mkdir -p ${dl_dir}
md5sum=$( md5 -q /usr/jails/export/${jname}.img | awk '{printf $1}' )
flatsize=$( stat -f "%z" /usr/jails/export/${jname}.img | awk '{printf $1}' )
mystr="amd64_${ver}|${jname}|amd64|${ver}|pgadmin4 service"

if grep "${mystr}" ${index}; then
	cp -a ${index} ${index}.bak
	grep -v "${mystr}" ${index}.bak > ${index}
fi

full_str="${mystr}|${md5sum}|${flatsize}|0|"
mv /usr/jails/export/pgadmin4.img ${dl_dir}/
echo "${full_str}" >> ${index}

if [ ! -d /usr/jails/jails-data/nginx-data/usr/local/www/www.bsdstore.ru/img/amd64/amd64/${ver}/${jname} ]; then
	mkdir -p /usr/jails/jails-data/nginx-data/usr/local/www/www.bsdstore.ru/img/amd64/amd64/${ver}/${jname}
fi

cat > /usr/jails/jails-data/nginx-data/usr/local/www/www.bsdstore.ru/img/amd64/amd64/${ver}/${jname}/mirror.html <<EOF
https://dl.bsdstore.ru
EOF
