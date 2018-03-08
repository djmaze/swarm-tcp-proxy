#!/bin/sh
set -e
set -x

haproxy_cfg="/usr/local/etc/haproxy/haproxy.cfg"
send_proxy_arg="send-proxy"

sed -i "s/\${SERVICE_NAME}/${SERVICE_NAME}/;
        s/\${SERVICE_PORT}/${SERVICE_PORT}/" \
        "$haproxy_cfg"

if [ -n "$DISABLE_PROXY_PROTOCOL" ]; then
  send_proxy_arg=""
fi
sed -i "s/\${SEND_PROXY}/${send_proxy_arg}/" \
       "$haproxy_cfg"

exec /docker-entrypoint.sh $*
