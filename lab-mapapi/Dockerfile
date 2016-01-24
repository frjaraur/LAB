FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

WORKDIR /MAPAPI

ENV SERVICEINSTALL WORKDIR

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    apt-utils autoconf binutils-doc bison build-essential flex git libpango1.0-dev \
    python-software-properties zip wget


## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs


## MAP API

RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd Windshaft-cartodb && git checkout master && \ 
	npm install && cp config/environments/development.js.example config/environments/development.js
	
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	

VOLUME /MAPAPI

WORKDIR /MAPAPI/Windshaft-cartodb
EXPOSE 8181

CMD ["node", "app.js", "development"]
