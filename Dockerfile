# Must use URL
FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com
#ADD https://cdn.gogs.io/gogs_v0.9.13_linux_amd64.tar.gz /tmp/gogs.tar.gz
RUN sudo rpm --import https://rpm.packager.io/key && echo "[gogs]
name=Repository for pkgr/gogs application.
baseurl=https://rpm.packager.io/gh/pkgr/gogs/centos7/pkgr
enabled=1" | sudo tee /etc/yum.repos.d/gogs.repo

RUN yum install -y gogs openssh-clients
#RUN yum install -y tar openssh-clients git python-setuptools && \
#    easy_install supervisor && \
#    useradd -U gogs && \
#    useradd -U git && \
#    mkdir -p /var/gogs && \
#    mkdir -p /var/gogs/gogs/custom/conf && \
#    mkdir -p /var/gogs/gogs-repositories && \
#    mkdir -p /var/gogs/gogs-log && \
#    mkdir -p /var/log/supervisor && \
#    (cd /var/gogs && tar -xzf /tmp/gogs.tar.gz) && \
#    chown -R gogs:gogs /var/gogs

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY app.ini /var/gogs/gogs/custom/conf/app.ini

#USER gogs
EXPOSE 80 3000
#CMD ["/usr/bin/supervisord"]
#CMD ["/var/gogs/gogs/gogs","web"]
CMD ["top", "-b"]
