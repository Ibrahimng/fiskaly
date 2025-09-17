FROM registry.access.redhat.com/ubi8/ubi

RUN dnf -y update && \
    dnf install -y openssh-server python39 passwd shadow-utils && \
    alternatives --set python3 /usr/bin/python3.9 || true && \
    echo "root:rootpass" | chpasswd && \
    mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

