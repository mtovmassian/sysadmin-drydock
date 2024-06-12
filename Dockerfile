FROM ubuntu:22.04 as ubuntu
RUN \
    apt update \
    && apt install -y curl \
    && curl -s -L https://raw.githubusercontent.com/mtovmassian/linux-survivalist/main/src/survive.sh | bash -s -- --quiet \
    && rm -rf /var/lib/apt/lists/*