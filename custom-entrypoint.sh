#!/bin/sh
set -euo pipefail

haproxy_cfg="/usr/local/etc/haproxy/haproxy.cfg"
send_proxy_arg="send-proxy"

SERVICES="${SERVICES:-}"
DISABLE_PROXY_PROTOCOL="${DISABLE_PROXY_PROTOCOL:-}"
CONNECTION_TIMEOUT="${CONNECTION_TIMEOUT:-}"

if [[ -n "$SERVICES" ]]; then
  num=0
  for service in $SERVICES; do
    let "num++" || true
    name="$(echo $service | cut -d ":" -f 1)"
    port="$(echo $service | cut -d ":" -f 2)"
    sed "s/\${NUM}/${num}/; \
         s/\${PROXY_PORT}/${port}/; \
         s/\${SERVICE_NAME}/${name}/; \
         s/\${SERVICE_PORT}/${port}/; \
         s/\${CONNECTION_TIMEOUT}/${CONNECTION_TIMEOUT}/g" \
         "$haproxy_cfg.tpl" >>"$haproxy_cfg"
  done
else
  sed "s/\${NUM}/1/; \
       s/\${PROXY_PORT}/8000/; \
       s/\${SERVICE_NAME}/${SERVICE_NAME}/; \
       s/\${SERVICE_PORT}/${SERVICE_PORT}/; \
       s/\${CONNECTION_TIMEOUT}/${CONNECTION_TIMEOUT}/g" \
       "$haproxy_cfg.tpl" >"$haproxy_cfg"
fi

if [ -n "$DISABLE_PROXY_PROTOCOL" ]; then
  send_proxy_arg=""
fi
sed -i "s/\${SEND_PROXY}/${send_proxy_arg}/" \
       "$haproxy_cfg"

exec /docker-entrypoint.sh $*
