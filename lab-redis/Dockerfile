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

RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 900 .*\)$/# \1\n\#save 900/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 300 .*\)$/# \1\n\save 120/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 60 .*\)$/# \1\nsave 60 100/' /etc/redis/redis.conf && \
  sed -i 's/^\(appendonly .*\)$/# \1\nappendonly yes/' /etc/redis/redis.conf && \
  sed -i 's/^\(appendfsync .*\)$/# \1\nappendfsync always/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["redis-server", "/etc/redis/redis.conf"]

# Expose ports.
EXPOSE 6379
