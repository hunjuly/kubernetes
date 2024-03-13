FROM ubuntu:focal

RUN apt-get update

# 개발 도구 설치
RUN apt-get install -y git curl jq tree vim

# Docker 설치
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh ./get-docker.sh
