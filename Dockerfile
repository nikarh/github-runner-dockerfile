FROM ubuntu:23.10

ARG RUNNER_VERSION="2.314.1"

RUN sed -i s/archive/de.archive/ /etc/apt/sources.list \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt -qq update \
    && apt install -y --no-install-recommends ca-certificates curl sudo libicu-dev jq docker.io \
    && echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers \
    && usermod -aG docker ubuntu

USER ubuntu
WORKDIR /home/ubuntu

RUN curl -sS -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar xz

USER root

COPY start.sh start.sh

CMD ["./start.sh"]
