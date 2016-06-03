# Must use URL
FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com
ADD https://cdn.gogs.io/gogs_v0.9.13_linux_amd64.tar.gz /tmp/gogs.tar.gz
RUN yum install -y tar openssh-clients git && \
    useradd -U gogs && \
    useradd -U git && \
    mkdir -p /var/gogs && \
    (cd /var/gogs && tar -xzf /tmp/gogs.tar.gz)
# Install system utils & Gogs runtime dependencies
RUN uname -a

EXPOSE 80 3000
ENTRYPOINT ["/var/gogs/gogs/gogs", "web"]
