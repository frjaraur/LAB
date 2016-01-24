#
#
#	PostgreSQL Dockerfile
#
#
FROM ubuntu:precise

# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    apt-utils autoconf binutils-doc bison build-essential flex git \
    python-software-properties zip wget

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu 

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN mkdir /docker-entrypoint-initdb.d

#RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

ENV PG_MAJOR 9.3
#ENV PG_VERSION 9.3.10-1.pgdg80+1

#RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list

RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common \
	postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 postgresql-plpython-9.3    
 
RUN add-apt-repository ppa:cartodb/pg-schema-trigger && apt-get update && \
	apt-get install -y postgresql-9.3-pg-schema-triggers

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


RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

COPY docker-entrypoint-initdb.d/cartodb_customizations.sql docker-entrypoint-initdb.d/cartodb_customizations.sql

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
