FROM alpine:3.23

LABEL maintainer="OpenAI Codex"
LABEL name="tor-proxy"
LABEL version="latest"

RUN apk -U upgrade && \
    apk -v add tor lyrebird curl privoxy && \
    chmod 700 /var/lib/tor && \
    mkdir -p /run/privoxy && \
    chown -R tor:root /run/privoxy /etc/privoxy /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version

COPY --chown=tor:root torrc /etc/tor/
COPY --chown=tor:root privoxy.config /etc/privoxy/config
COPY --chown=tor:root entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

HEALTHCHECK --timeout=10s --start-period=60s \
  CMD curl --fail --socks5-hostname localhost:9150 -I -L 'https://www.facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion/' || exit 1

USER tor

EXPOSE 8118/tcp 8853/udp 9001/tcp 9150/tcp

CMD ["/usr/local/bin/entrypoint.sh"]
