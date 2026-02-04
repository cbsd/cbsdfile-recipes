## !! This file is part of CBSD PXE/DNSMASQ service
#  !! Don't edit this file inside the jail, use
#  ~cbsd/jails-system/$jname/share/dnsmasq.conf.tpl
# and re-run:
#   cbsd jconfig jname=$jname net
# or: 
#   cbsd jconfig jname=$jname net-tui

# For additional local dnsmasq configuration like DNS blacklisting, it's
# recommended to use separate /etc/dnsmasq.d/local.conf files

# port=0 disables the DNS service of dnsmasq
port=0

# enable-tftp enables the TFTP service of dnsmasq
enable-tftp

# FHS 2.3+ recommends /srv for tftp (debian #477109, LP #84615)
tftp-root=/usr/local/srv/pxe

# Log lots of extra information about DHCP transactions
log-dhcp

# IP ranges to hand out
dhcp-range=%%CBSD_DNSMASQ_RANGE%%

# If another DHCP server is present on the network, a proxy range may be used
# instead. This makes dnsmasq provide boot information but not IP leases.
#dhcp-range=set:proxy,192.168.0.0,proxy,255.255.255.0

#dhcp-host=3c:7c:3f:be:06:1b,192.168.0.100

# Set some tags to be able to separate client settings later on.
dhcp-match=set:X86PC,option:client-arch,0
dhcp-match=set:X86-64_EFI,option:client-arch,7
# Due to rfc4578 errata, sometimes BC_EFI=9 is misused instead of X86-64_EFI=7:
dhcp-match=set:X86-64_EFI,option:client-arch,9
dhcp-mac=set:rpi,b8:27:eb:*:*:*
dhcp-mac=set:rpi,dc:a6:32:*:*:*
dhcp-mac=set:rpi,e4:5f:01:*:*:*

# Check if iPXE has the features we need: http://ipxe.org/howto/dhcpd
# http && menu && ((pxe && bzimage) || efi)
dhcp-match=set:ipxe-http,175,19
dhcp-match=set:ipxe-menu,175,39
dhcp-match=set:ipxe-pxe,175,33
dhcp-match=set:ipxe-bzimage,175,24
dhcp-match=set:ipxe-efi,175,36
tag-if=set:ipxe,tag:ipxe-http,tag:ipxe-menu,tag:ipxe-pxe,tag:ipxe-bzimage
tag-if=set:ipxe,tag:ipxe-http,tag:ipxe-menu,tag:ipxe-efi

# In proxy DHCP mode, the server ONLY sends its IP and the following filename.
# Service types: man dnsmasq or https://tools.ietf.org/html/rfc4578#section-2.1
# PXE services in non proxy subnets sometimes break UEFI netboot, so tag:proxy.
pxe-service=tag:proxy,tag:!ipxe,X86PC,"undionly.kpxe",undionly.kpxe
pxe-service=tag:proxy,tag:!ipxe,X86-64_EFI,"snponly.efi",snponly.efi
pxe-service=tag:proxy,tag:ipxe,X86PC,"main.ipxe",main.ipxe
pxe-service=tag:proxy,tag:ipxe,X86-64_EFI,"main.ipxe",main.ipxe
pxe-service=tag:rpi,X86PC,"Raspberry Pi Boot   ",unused

# Specify the boot filename for each tag, relative to tftp-root.
# If multiple lines with tags match, the last one is used.
# See: https://www.syslinux.org/wiki/index.php?title=PXELINUX#UEFI
dhcp-boot=tag:!ipxe,tag:X86PC,undionly.kpxe
dhcp-boot=tag:!ipxe,tag:X86-64_EFI,snponly.efi
dhcp-boot=tag:ipxe,main.ipxe

# Proxy DHCP clients don't receive any DHCP options like root-path.
# So we set root-path in the kernel cmdline from main.ipxe
dhcp-option=option:root-path,ipxe-menu-item

#dhcp-option=interface:enp0s6,option:router,192.168.0.1
dhcp-option=option:router,%%CBSD_DNSMASQ_GW4%%

# nameserver
# #dhcp-option=option6:dns-server,[1234::77],[1234::88]
#dhcp-option=1,255.255.255.224
%%CBSD_DNSMASQ_NS%%
