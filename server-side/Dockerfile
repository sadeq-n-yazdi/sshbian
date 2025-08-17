# Use a slim Debian base image for a smaller footprint
FROM debian:stable-slim

# Set a non-interactive mode for the build to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Define a build-time argument for the user password.
# This password is no longer used for SSH but can be used for local console login.
#ARG DEV_USER_PASSWORD

# Install the necessary packages.
# 'iputils-ping' for ping, 'dnsutils' for dig, host, and whois.
# 'iproute2' is included by default in most Debian images.
# 'procps' contains htop.

RUN apt-get update && \
    apt-get install -y openssh-server \
    iptables \
    iputils-ping \
    tree \
    dnsutils \
    traceroute \
    whois \
    htop \
    bash

RUN apt-get install -y \
    sudo git build-essential zsh nano vim \
    iputils-arping iputils-clockdiff iputils-ping iputils-tracepath \
    iproute2 ipset iptables iproute2 net-tools net-tools

RUN apt-get install -y curl wget aria2

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Create a new user and add them to the sudo group.
# This user can still use password auth for a local shell.
RUN useradd -m -s /bin/bash devuser && \
    adduser devuser sudo
    # echo "devuser:${DEV_USER_PASSWORD}" | chpasswd && \

# Configure SSH for public key authentication only.
# Permit root login, but enforce public key authentication.
#RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config && \
RUN sed -i 's/#?PermitRootLogin [a-zA-Z-]+[\s]*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#?PasswordAuthentication [a-zA-Z-]+[\s]*$/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#?PubkeyAuthentication [a-zA-Z-]+[\s]*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config 

RUN sed -i 's/#?PermitTunnel [a-zA-Z-]+[\s]*$/PermitTunnel yes/' /etc/ssh/sshd_config 
RUN sed -i 's/#?AllowStreamLocalForwarding [a-zA-Z-]+[\s]*$/AllowStreamLocalForwarding yes/' /etc/ssh/sshd_config 
RUN sed -i 's/#?AllowTcpForwarding [a-zA-Z-]+[\s]*$/AllowTCPForyypwarding all/' /etc/ssh/sshd_config 
RUN sed -i 's/#?GatewayPorts [a-zA-Z-]+[\s]*$/GatewayPorts clientspecified/' /etc/ssh/sshd_config 

    # Disallow GSSAPI authentication to speed up login
RUN echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PermitTunnel yes" >> /etc/ssh/sshd_config &&\
    echo "" >> /etc/ssh/sshd_config

    # echo "MaxSessions 0" >> /etc/ssh/sshd_config # && \
    # Create the necessary directory for SSH server to run
    

RUN mkdir -p /var/run/sshd  /root/.ssh 

COPY authorized_keys /root/.ssh/authorized_keys 
#RUN chmod og-rwx /root/.ssh/authorized_keys  && chown root:root authorized_keys
RUN test [ -z "$(cat /root/.ssh/authorized_keys)|grep 'code@sadeq'" ] || echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTwSUs/iCJFNLlryuukD6sx/HTn3CHjV7eHtpfbAapB code@sdaeq.uk' >> /root/.ssh/authorized_keys


# Expose port 22 for SSH
EXPOSE 22

# Run the SSH server in the foreground.
CMD ["/usr/sbin/sshd", "-D", "-e"]

