FROM registry.access.redhat.com/rhel7
MAINTAINER cleciovarjao@gmail.com

# Install system utils & Gogs runtime dependencies
RUN uname -a

EXPOSE 80
ENTRYPOINT ["top", "-b"]
