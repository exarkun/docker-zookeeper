# Zookeeper
#
# Version 3.5.0-alpha

FROM exarkun/ubuntu:updated
MAINTAINER Jean-Paul Calderone jean-paul@clusterhq.com

ENV ZOOKEEPER_VERSION 3.5.0-alpha

# Install Java 6
RUN \
    apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java6-installer && \
    apt-get remove -y --purge software-properties-common && \
    apt-get autoclean

# ???
RUN locale-gen en_US en_US.UTF-8

# Get ZooKeeper.
RUN \
    apt-get update && \
    apt-get install -y curl && \
    cd /srv && \
    curl -O http://www.bizdirusa.com/mirrors/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    tar xf zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    rm zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    mv zookeeper-${ZOOKEEPER_VERSION} zookeeper && \
    chmod +x zookeeper zookeeper/bin/zkServer.sh && \
    mkdir -p /var/run/zookeeper && \
    apt-get remove -y --purge curl && \
    apt-get autoclean

ADD generate-config-and-start.sh /tmp/generate-config-and-start.sh
CMD /tmp/generate-config-and-start.sh
