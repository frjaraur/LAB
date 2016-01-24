### CartoDB Dockerfile



FROM ubuntu:precise

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8




WORKDIR /CARTODB

ENV CARTODBINSTALL /CARTODB

RUN apt-get update && \
    LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget apt-utils


## REDIS
RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/REDIS/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 900 .*\)$/# \1\n\#save 900/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 300 .*\)$/# \1\n\save 120/' /etc/redis/redis.conf && \
  sed -i 's/^\(save 60 .*\)$/# \1\nsave 60 100/' /etc/redis/redis.conf && \
  sed -i 's/^\(appendonly .*\)$/# \1\nappendonly yes/' /etc/redis/redis.conf && \
  sed -i 's/^\(appendfsync .*\)$/# \1\nappendfsync always/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(bind .*\)$/# \1\nbind 0.0.0.0/' /etc/redis/redis.conf

ENV REDIS /REDIS


## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs


## SQL API

ENV SQLAPI $CARTODBINSTALL/CartoDB-SQL-API
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd CartoDB-SQL-API && git checkout master && \
	npm install

COPY configs/sqlapi_development.js $SQLAPI/config/sqlapi_development.js




RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common    


RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    apt-utils autoconf binutils-doc bison build-essential flex git libpango1.0-dev \
    python-software-properties zip wget libjpeg-turbo8-dev
    
## MAP API
ENV MAPAPI $CARTODBINSTALL/Windshaft-cartodb
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd Windshaft-cartodb && git checkout master && \ 
	npm install

COPY configs/mapapi_development.js $MAPAPI/config/mapapi_development.js


RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common    


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
	apt-get install -y gdal-bin libgdal1-dev libgdal-dev
	
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

ENV CARTODBMAIN $CARTODBINSTALL/cartodb

RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	apt-get install -y gdal-bin libgdal1-dev libgdal-dev libicu-dev
	
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
	
RUN git clone --recursive https://github.com/CartoDB/cartodb.git && \
	cd cartodb && RAILS_ENV=development bundle install && npm install &&\
	CPLUS_INCLUDE_PATH=/usr/include/gdal C_INCLUDE_PATH=/usr/include/gdal PATH=$PATH:/usr/include/gdal \
	pip install --no-use-wheel -r python_requirements.txt && PATH=$PATH:$PWD/node_modules/grunt-cli/bin \
	bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development
	
#ENV CPLUS_INCLUDE_PATH /usr/include/gdal
#ENV C_INCLUDE_PATH /usr/include/gdal
#ENV PATH $PATH:/usr/include/gdal

#RUN pip install --no-use-wheel -r python_requirements.txt

#ENV PATH $PATH:$CARTODBINSTALL/cartodb/node_modules/grunt-cli/bin

#RUN bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development

ENV RAILS_ENV development

RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu 


COPY docker-entrypoint.sh /


VOLUME ["/CARTODB","/REDIS"]


#ENTRYPOINT ["/docker-entrypoint.sh"]

#EXPOSE 3000
#CMD ["start_all"]

##START REDIS
#CMD ["redis-server", "/etc/redis/redis.conf"]

#EXPOSE 6379


##START SQLAPI 
# WORKDIR /CARTODB/CartoDB-SQL-API
#EXPOSE 8080

#CMD ["node", "app.js", "development"]


## START MAPAPI
#WORKDIR /MAPAPI/Windshaft-cartodb
#EXPOSE 8181

#CMD ["node", "app.js", "development"]

