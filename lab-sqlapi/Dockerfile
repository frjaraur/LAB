FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

WORKDIR /SQLAPI

ENV SERVICEINSTALL WORKDIR

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    apt-utils autoconf binutils-doc bison build-essential flex git \
    python-software-properties zip wget


## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs


## NODAEMON
#RUN npm install -g nodaemon

## SQL API

RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd CartoDB-SQL-API && git checkout master && \
	npm install && cp config/environments/development.js.example config/environments/development.js
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

VOLUME /SQLAPI

WORKDIR /SQLAPI/CartoDB-SQL-API
EXPOSE 8080

CMD ["node", "app.js", "development"]
