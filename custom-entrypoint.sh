#!/bin/sh
set -e

sed -i "s/\${SERVICE_NAME}/${SERVICE_NAME}/;
        s/\${SERVICE_PORT}/${SERVICE_PORT}/" \
       /usr/local/etc/haproxy/haproxy.cfg

exec /docker-entrypoint.sh $*
