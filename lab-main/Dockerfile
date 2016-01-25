### CartoDB Main Dockerfile

FROM ubuntu:precise

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE = en_US

WORKDIR /CARTODB

ENV CARTODBINSTALL /CARTODB

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget apt-utils libjpeg-turbo8-dev

## REDIS
RUN add-apt-repository ppa:cartodb/redis && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server
ENV REDIS /REDIS

## POSTGRESQL Client
RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common    


## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs

## SQL API

ENV SQLAPI $CARTODBINSTALL/CartoDB-SQL-API
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd CartoDB-SQL-API && git checkout master && \
	npm install

    
## MAP API
ENV MAPAPI $CARTODBINSTALL/Windshaft-cartodb
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd Windshaft-cartodb && git checkout master && \ 
	npm install

## PIP
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py
## RUBY

RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
	tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0 && make install
	
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN gem install bundler &&  gem install compass


## EDITOR

RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y gdal-bin libgdal1-dev libgdal-dev
	
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

ENV CARTODBMAIN $CARTODBINSTALL/cartodb

RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	apt-get install -y gdal-bin libgdal1-dev libgdal-dev libicu-dev
	

ENV PATH $PATH:$CARTODBINSTALL/cartodb/node_modules/grunt-cli/bin
	
RUN git clone --recursive https://github.com/CartoDB/cartodb.git

RUN cd cartodb && RAILS_ENV=development bundle install && npm install &&\
	CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal PATH=$PATH:/usr/include/gdal \
	pip install --no-use-wheel -r python_requirements.txt && PATH=$PATH:$PWD/node_modules/grunt-cli/bin \
	bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development
	

ENV RAILS_ENV development

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu 

RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

### LASTEST FIXES ... Must be changed better...

COPY configs/mapapi_development.js $MAPAPI/config/environments/development.js
COPY configs/sqlapi_development.js $SQLAPI/config/environments/development.js
COPY configs/redis.conf $REDIS/redis.conf
COPY configs/main_app_config.yml $CARTODBMAIN/config/app_config.yml
COPY configs/main_database.yml $CARTODBMAIN/config/database.yml  

VOLUME ["/CARTODB","/REDIS"]

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3000 6379 8080 8181
CMD ["start_all"]
