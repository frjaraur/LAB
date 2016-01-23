FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get update && \
    LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget


## PIP
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py

## POSTGRESQL
    
RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common \
	postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 postgresql-plpython-9.3    
  
RUN add-apt-repository ppa:cartodb/pg-schema-trigger && apt-get update && \
	apt-get install -y postgresql-9.3-pg-schema-triggers

# Change PostgreSQL pg_hba.conf, everything else is the PostgreSQL default config
ADD cartodbfiles/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD cartodbfiles/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
RUN chown -R postgres /etc/postgresql/9.3/main

VOLUME /var/lib/postgresql

# Restart PostreSQL for security changes to take effect 
RUN service postgresql restart

# Create CartoDB users
ADD cartodbfiles/cartodb_install.sh /cartodbfiles/cartodb_install.sh
ENTRYPOINT ["/cartodbfiles/cartodb_install.sh","create_users"]

# CartoDB postgresql extension
# This is the first approach, we could use a simplest and update entrypoint with a script that uses git description and get from there the lastest version
ENV CARTODB_PG_LATEST 0.11.5-g2ab0594

RUN git clone https://github.com/CartoDB/cartodb-postgresql.git && cd cartodb-postgresql && \
	git checkout $CARTODB_PG_LATEST && make all install
	
## GIS

RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	apt-get install -y proj proj-bin proj-data libproj-dev \
	libjson0 libjson0-dev python-simplejson \
	libgeos-c1v5 libgeos-dev \
	gdal-bin libgdal1-dev libgdal-dev \
	ogr2ogr2-static-bin


	

## PostGIS

RUN apt-get install -y libxml2-dev	liblwgeom-2.1.8 postgis postgresql-9.3-postgis-2.2 \
 	postgresql-9.3-postgis-scripts
 	
	
ENTRYPOINT ["/cartodbfiles/cartodb_install.sh","postgis"]

#RUN service postgresql start && sleep 5

#RUN cd cartodb-postgresql && PGUSER=postgres PGHOST=localhost make installcheck



## REDIS

RUN add-apt-repository ppa:cartodb/redis && apt-get update && apt-get install -y redis-server
ADD cartodbfiles/redis.conf /cetc/redis/redis.conf


## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs


## SQL API

RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && cd CartoDB-SQL-API && git checkout master && \
	npm install && cp config/environments/development.js.example config/environments/development.js
	
## Should be Started with "node app.js development" 


## MAPS API

RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && cd Windshaft-cartodb && git checkout master && \ 
	npm install && cp config/environments/development.js.example config/environments/development.js

## Should be started with "node app.js development"



## RUBY

RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
	tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0 && make install
	
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN gem install bundler &&  gem install compass



## EDITOR
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

RUN git clone --recursive https://github.com/CartoDB/cartodb.git && cd cartodb && RAILS_ENV=development bundle install && \
	npm install &&  pip install --no-use-wheel -r python_requirements.txt

#MAL ENV PATH $PATH:$PWD/node_modules/grunt-cli/bin
RUN cd cartodb && bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development
RUN cd cartodb && config/app_config.yml.sample config/app_config.yml && cp config/database.yml.sample config/database.yml	
RUN cd cartodb && RAILS_ENV=development bundle exec rake db:migrate
RUN cd cartodb && RAILS_ENV=development bundle exec rake db:setup


	
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
