FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        default-jre && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash user && \
    echo "user:password" | chpasswd

RUN mkdir -p /home/user/.ssh
COPY proj_key.pub /home/user/.ssh/authorized_keys

RUN chown -R user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    chmod 600 /home/user/.ssh/authorized_keys

COPY sshd.conf /etc/ssh/sshd_config.d/ssh.conf

WORKDIR /app
COPY app.jar /app/app.jar

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
