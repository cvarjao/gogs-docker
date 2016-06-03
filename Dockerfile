# Must use URL
FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com
ADD https://cdn.gogs.io/gogs_v0.9.13_linux_amd64.tar.gz /tmp/gogs.tar.gz
RUN yum install -y tar openssh-clients git supervisor && \
    useradd -U gogs && \
    useradd -U git && \
    mkdir -p /var/gogs && \
    mkdir -p /var/log/supervisor && \
    (cd /var/gogs && tar -xzf /tmp/gogs.tar.gz) && \
    chown -R gogs:gogs /var/gogs

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 3000
CMD ["/usr/bin/supervisord"]
