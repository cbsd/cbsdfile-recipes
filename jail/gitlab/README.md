## Gitlab CBSD template (static)

Generate a GitLab jail container for CBSD.
The script is used to generate the actual container image, which can be installed via the command:

  # cbsd repo action=get sources=img name=gitlab

or:

  # cbsd jcreate jname=myjail from=

or register as gold image ( e.g.: ZFS COW )

  # cbsd images ...

## Quick-Start

  Create a container with default options:

  # cbsd up

  As a result of the work, you will get a working gitlab service on IPv4 address with
  UI available on http://<ip>

  default username: 'root'
  default password: 'yourpassword'
  SSH port: 22

  All data is located inside the container and will be deleted when the jail is destroyed.

## Custom setup

 Through the environment variables you can configure some initial settings for yourself at the start.

 Config Variables:

GITLAB_ROOT_PASSWORD "yourpassword"
GITLAB_FQDN 0
GITLAB_PG_VER 13

GITLAB_HTTP_PORT 80
GITLAB_HTTPS_PORT 0

GITLAB_HTTP_EXPOSE 0
GITLAB_HTTPS_EXPOSE 0
GITLAB_SSH_PORT 22

GITLAB_SSH_EXPOSE 0

### Example Case 1:

  Use static/already initialized IPv4/IPv6 address on the host with alternative SSH (222) and HTTP (8080) port, set jail autostart,
  also set hostname jail to 'jail1.my.domain' ( its not GITLAB_FQDN server_name ):

  # env GITLAB_HTTP_PORT=8080 GITLAB_SSH_PORT=222 cbsd up ip4_addr=46.4.100.29,2a01:4f8:140:918b::1 astart=1 interface=0 host_hostname="jail1.my.domain"

### Example Case 2

  Set custom FQDN (gitlab.example.com) and 'root' user password (toor), get auto-IP for IPv4 and IPv6 (see `nodeippool` and `nodeip6pool` in `cbsd-initenv-tui` ),
  also expose GitLab HTTP port to $nodeip:9000.

  # env GITLAB_HTTP_EXPOSE=9000 GITLAB_ROOT_PASSWORD="toor" GITLAB_FQDN="gitlab.example.com"

## SSL/HTTPS endpoints and certificate

wip

## External volume

wip

## Upgrading

wip

## Scaling

wip

|1|2|
|3|4|
|5|6|
