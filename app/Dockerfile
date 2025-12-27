FROM ubuntu:24.04
RUN apt-get update && apt-get install -y default-jre openssh-server
WORKDIR /app
COPY . /app
COPY sshd.conf /etc/ssh/sshd_config.d/ssh.conf
CMD ["java", "-jar", "app.jar"]
EXPOSE 22
RUN useradd -m user && echo "user:password" | chpasswd
RUN mkdir /home/user/.ssh
RUN cat proj_key.pub > /home/user/.ssh/authorized_keys
RUN service ssh start
