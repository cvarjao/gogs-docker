# Must use URL
FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com
ADD https://cdn.gogs.io/gogs_v0.9.13_linux_amd64.tar.gz /tmp/gogs.tar.gz
RUN yum install tar -y && \
    useradd -U gogs && \
    mkdir -p /var/gogs && \
    tar xzf -C /var/gogs /tmp/gogs.tar.gz
# Install system utils & Gogs runtime dependencies
RUN uname -a

EXPOSE 80
ENTRYPOINT ["top", "-b"]
