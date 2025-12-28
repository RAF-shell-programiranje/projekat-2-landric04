FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-client && \
    rm -rf /var/lib/apt/lists/*

COPY ssh.conf /root/.ssh/config

WORKDIR /app
COPY monitor.* .

RUN chmod +x monitor.sh
CMD ["./monitor.sh"]
