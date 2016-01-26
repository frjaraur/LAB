### CartoDB Main Dockerfile

FROM ubuntu:precise

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE = en_US
ENV DEBIAN_FRONTEND noninteractive 

WORKDIR /CARTODB

ENV CARTODBINSTALL /CARTODB

## Base Packages, I added some network tools for debugging purposes :P
RUN apt-get update && \
    apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget apt-utils libjpeg-turbo8-dev \
    net-tools iputils-ping


## REDIS Install
RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server
ENV REDIS /REDIS


## POSTGRESQL Client Install
RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common    


## NODEJS Install
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs


## SQL API Install
ENV SQLAPI $CARTODBINSTALL/CartoDB-SQL-API
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd CartoDB-SQL-API && git checkout master && \
	npm install

    
## MAP API Install
ENV MAPAPI $CARTODBINSTALL/Windshaft-cartodb
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd Windshaft-cartodb && git checkout master && \ 
	npm install

## PIP Install
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py


## RUBY And Some Gems Install
RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
	tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0 && make install && cd .. \
	rm -rf ruby-install-0.5.0.tar.gz ruby-install-0.5.0
	
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN gem install bundler &&  gem install compass


## EDITOR Install
RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	apt-get install -y gdal-bin libgdal1-dev libgdal-dev libicu-dev
	
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

ENV CARTODBMAIN $CARTODBINSTALL/cartodb

ENV PATH $PATH:$CARTODBINSTALL/cartodb/node_modules/grunt-cli/bin
	
RUN git clone --recursive https://github.com/CartoDB/cartodb.git

RUN cd cartodb && RAILS_ENV=development bundle install && npm install &&\
	CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal PATH=$PATH:/usr/include/gdal \
	pip install --no-use-wheel -r python_requirements.txt && PATH=$PATH:$PWD/node_modules/grunt-cli/bin \
	bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development
	
ENV RAILS_ENV development

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

CMD ["first_start","development"]
