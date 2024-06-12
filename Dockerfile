FROM ubuntu:22.04 as ubuntu
RUN \
    # Prerequisites
    apt update \
    && apt install -y \
        curl \
        openssh-server
RUN \
    # Essential tools
    curl -s -L https://raw.githubusercontent.com/mtovmassian/linux-survivalist/main/src/survive.sh | bash -s -- --quiet \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*
COPY \
    sshd_config \
    /etc/ssh/sshd_config
EXPOSE 22
CMD /etc/init.d/ssh start && sleep infinity