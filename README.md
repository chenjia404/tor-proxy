# tor-proxy

[![Docker Hub](https://img.shields.io/docker/v/chenjia404/tor-proxy?sort=semver&label=docker%20hub)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Docker Pulls](https://img.shields.io/docker/pulls/chenjia404/tor-proxy?label=pulls)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Image Size](https://img.shields.io/docker/image-size/chenjia404/tor-proxy/latest?label=size)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Docker Publish](https://github.com/chenjia404/tor-proxy/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/chenjia404/tor-proxy/actions/workflows/docker-publish.yml)

[中文文档](./README.zh-CN.md)

A minimal Tor Docker image based on `PeterDaveHello/tor-socks-proxy`, keeping the SOCKS5 proxy use case, adding an HTTP proxy via Privoxy, and enabling relay mode by default.

Docker Hub: <https://hub.docker.com/r/chenjia404/tor-proxy>

Default behavior:

- `8118/tcp`: HTTP proxy via Privoxy
- `9150/tcp`: SOCKS5 proxy
- `8853/udp`: DNS over Tor
- `9001/tcp`: Tor relay `ORPort`
- Runs as a non-exit relay by default, so it does not expose exit traffic directly to the public Internet

## Start

```bash
docker run -d --restart=always --name tor-proxy \
  -p 127.0.0.1:8118:8118/tcp \
  -p 127.0.0.1:9150:9150/tcp \
  -p 127.0.0.1:8853:8853/udp \
  -p 9001:9001/tcp \
  chenjia404/tor-proxy:latest
```

Or:

```bash
docker compose up -d
```

## Automated builds

GitHub Actions includes a monthly scheduled build that rebuilds and pushes `chenjia404/tor-proxy`.

Required repository secrets:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

## Verify the proxies

HTTP proxy:

```bash
curl -x http://127.0.0.1:8118 https://check.torproject.org/api/ip
```

SOCKS5 proxy:

```bash
curl --socks5-hostname 127.0.0.1:9150 https://check.torproject.org/api/ip
```

## Notes

- Relay mode is enabled by default via `ORPort 9001` in `torrc`.
- `privoxy` forwards HTTP traffic to Tor through `127.0.0.1:9150`.
- The current config sets `ExitRelay 0`, so this is a middle relay, not an exit relay.
- If you want to participate on the public Tor network, the host must allow inbound `9001/tcp`, and you should replace `ContactInfo` with your own contact details.
