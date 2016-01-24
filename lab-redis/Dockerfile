FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

WORKDIR /REDIS

ENV SERVICEINSTALL WORKDIR

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common apt-utils \
    python-software-properties 

## REDIS

RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server
ADD servicefiles/redis.conf /etc/redis/redis.conf

RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

VOLUME ["/var/lib/redis","/etc/redis" "/REDIS"]


CMD  ["/usr/bin/redis-server", "/etc/redis/redis.conf"]

EXPOSE      6379