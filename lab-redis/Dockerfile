#
# Redis Dockerfile
#
FROM ubuntu:precise

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
	apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
	apt-utils python-software-properties 

## REDIS

RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server
COPY config/redis.conf /etc/redis/redis.conf


# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379
