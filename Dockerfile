# Must use URL
FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com

ENV GOGS_CUSTOM /home/gogs

#ADD https://cdn.gogs.io/gogs_v0.9.13_linux_amd64.tar.gz /tmp/gogs.tar.gz
RUN rpm --import https://rpm.packager.io/key && \
    echo '[gogs]' >> /tmp/gogs.repo && \
    echo 'name=Repository for pkgr/gogs application.' >> /tmp/gogs.repo && \
    echo 'baseurl=https://rpm.packager.io/gh/pkgr/gogs/centos7/pkgr' >> /tmp/gogs.repo && \
    echo 'enabled=1' >> /tmp/gogs.repo && \
    cat /tmp/gogs.repo | tee /etc/yum.repos.d/gogs.repo && \
    yum install -y tar gogs openssh-clients sudo s6 cronie && \
    sed -i '/Defaults    requiretty/s/^/#/' /etc/sudoers && \
    yum clean all -y

ADD https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 /usr/local/bin/gosu
ADD https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64.asc /usr/local/bin/gosu.asc

# Add s6 overlay (https://github.com/just-containers/s6-overlay)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.17.2.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" --exclude="./sbin" && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin ./sbin && \
    chmod +x /usr/local/bin/gosu

#RUN yum install -y tar openssh-clients git python-setuptools && \
#    easy_install supervisor && \
#    useradd -U git && \
#    mkdir -p /var/gogs && \
#    mkdir -p /var/gogs/gogs/custom/conf && \
#    mkdir -p /var/gogs/gogs-repositories && \
#    mkdir -p /var/gogs/gogs-log && \
#    mkdir -p /var/log/supervisor && \
#    (cd /var/gogs && tar -xzf /tmp/gogs.tar.gz) && \
#    chown -R gogs:gogs /var/gogs

COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY app.ini /tmp/gogs-app.ini
COPY ./files/ /

RUN sudo -u gogs mkdir -p /opt/gogs/custom/conf && \
    cp /tmp/gogs-app.ini /opt/gogs/custom/conf/app.ini && \
    ls -la /opt/gogs/custom/conf/app.ini && \
    mkdir -p /app/gogs/ && mkdir -p /data/gogs/ && \
    mkdir -p /app/gogs/s6 && \
    chmod +x /app/gogs/docker/start.sh && \
    find /app/gogs/docker/s6 -type f -exec chmod +x {} \; && \
    find /app -ls

#USER gogs
EXPOSE 80 3000
WORKDIR /home/gogs
VOLUME ["/data"]

#CMD ["/usr/bin/supervisord"]
ENTRYPOINT ["/app/gogs/docker/start.sh"]
#CMD ["top", "-b"]
