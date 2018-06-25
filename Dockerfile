# Use 1.8.8 for now until https://github.com/docker-library/haproxy/issues/68 is fixed
FROM haproxy:1.8.8-alpine

ENV CONNECTION_TIMEOUT 5m

COPY custom-entrypoint.sh /
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.tpl

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
