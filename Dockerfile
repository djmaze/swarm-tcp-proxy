FROM haproxy:alpine

ENV CONNECTION_TIMEOUT 5m
ENV SERVICE_NAME app
ENV SERVICE_PORT 8000

COPY custom-entrypoint.sh /
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
EXPOSE 8000/tcp
