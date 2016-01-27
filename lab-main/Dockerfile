### CartoDB Main Dockerfile

FROM ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

ENV DEBIAN_FRONTEND noninteractive 

WORKDIR /CARTODB

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE = en_US


ENV CARTODBINSTALL /CARTODB
ENV REDIS /REDIS
ENV SQLAPI $CARTODBINSTALL/CartoDB-SQL-API
ENV MAPAPI $CARTODBINSTALL/Windshaft-cartodb
ENV CARTODBMAIN $CARTODBINSTALL/cartodb

ENV RAILS_ENV development


RUN apt-get update && \
    apt-get install -y software-properties-common \
    python-software-properties apt-utils

## Add Repositories
RUN add-apt-repository ppa:cartodb/redis && \
	add-apt-repository ppa:cartodb/postgresql-9.3 && \
	add-apt-repository ppa:cartodb/nodejs-010 && \
	add-apt-repository ppa:cartodb/gis

## Base Packages, I added some network tools for debugging purposes :P
RUN apt-get update && \
    apt-get install -y autoconf binutils-doc bison build-essential flex git \
    libpango1.0-dev libreadline6-dev openssl python-all-dev imagemagick unp zip wget \
    libjpeg-turbo8-dev redis-server libpq5 libpq-dev postgresql-client-9.3 \
    postgresql-client-common nodejs gdal-bin libgdal1-dev libgdal-dev libicu-dev \
    net-tools iputils-ping


## SQL API Install
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd $CARTODBINSTALL/CartoDB-SQL-API && \
	git checkout master && 	npm install

    
## MAP API Install
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd $CARTODBINSTALL/Windshaft-cartodb && \
	git checkout master && npm install

## PIP Install
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py


## RUBY And Some Gems Install
RUN wget -O /tmp/ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
	cd /tmp && tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0 && make install
	
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN gem install bundler &&  gem install compass

## EDITOR Install
	
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

ENV PATH $PATH:$CARTODBMAIN/node_modules/grunt-cli/bin
RUN git clone --recursive https://github.com/CartoDB/cartodb.git

RUN cd $CARTODBMAIN && RAILS_ENV=development bundle install && npm install && \
	CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal PATH=$PATH:/usr/include/gdal \
	pip install --no-use-wheel -r python_requirements.txt && PATH=$PATH:$PWD/node_modules/grunt-cli/bin \
	bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu 

RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


## Put Some Config Files for Applications
COPY configs/mapapi_development.js $MAPAPI/config/environments/development.js
COPY configs/sqlapi_development.js $SQLAPI/config/environments/development.js
COPY configs/redis.conf $REDIS/redis.conf
COPY configs/main_app_config.yml $CARTODBMAIN/config/app_config.yml
COPY configs/main_database.yml $CARTODBMAIN/config/database.yml  

## Volumes to store
VOLUME ["/CARTODB","/REDIS"]

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000 6379 8080 8181

CMD [ "first_start",$RAILS_ENV ]
