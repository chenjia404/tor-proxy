# tor-proxy

[![Docker Hub](https://img.shields.io/docker/v/chenjia404/tor-proxy?sort=semver&label=docker%20hub)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Docker Pulls](https://img.shields.io/docker/pulls/chenjia404/tor-proxy?label=pulls)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Image Size](https://img.shields.io/docker/image-size/chenjia404/tor-proxy/latest?label=size)](https://hub.docker.com/r/chenjia404/tor-proxy)
[![Docker Publish](https://github.com/chenjia404/tor-proxy/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/chenjia404/tor-proxy/actions/workflows/docker-publish.yml)

[English README](./README.md)

基于 `PeterDaveHello/tor-socks-proxy` 改出来的一个最小 Tor Docker 镜像，保留 SOCKS5 代理用途，增加基于 Privoxy 的 HTTP 代理，并且默认启用 relay。

Docker Hub：<https://hub.docker.com/r/chenjia404/tor-proxy>

默认行为：

- `8118/tcp`: 通过 Privoxy 提供 HTTP 代理
- `9150/tcp`: SOCKS5 代理
- `8853/udp`: DNS over Tor
- `9001/tcp`: Tor relay `ORPort`
- 默认是非 exit relay，避免把出口流量直接暴露到公网

## 启动

```bash
docker run -d --restart=always --name tor-proxy \
  -p 127.0.0.1:8118:8118/tcp \
  -p 127.0.0.1:9150:9150/tcp \
  -p 127.0.0.1:8853:8853/udp \
  -p 9001:9001/tcp \
  chenjia404/tor-proxy:latest
```

或者：

```bash
docker compose up -d
```

## 自动构建

项目已包含一个 GitHub Actions 工作流，会每个月自动重新构建并推送 `chenjia404/tor-proxy`。

仓库需要配置以下 secrets：

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`

## 验证代理

HTTP 代理：

```bash
curl -x http://127.0.0.1:8118 https://check.torproject.org/api/ip
```

SOCKS5 代理：

```bash
curl --socks5-hostname 127.0.0.1:9150 https://check.torproject.org/api/ip
```

## 说明

- relay 默认开启依赖 `torrc` 里的 `ORPort 9001`。
- `privoxy` 会把 HTTP 请求转发到 `127.0.0.1:9150` 上的 Tor SOCKS5 代理。
- 当前配置默认 `ExitRelay 0`，因此它是中继节点，不是出口节点。
- 如果你要真的参与公网 relay，宿主机需要开放 `9001/tcp`，并且建议把 `ContactInfo` 改成你自己的联系方式。
