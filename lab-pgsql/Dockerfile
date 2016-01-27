### PostgreSQL Dockerfile

FROM ubuntu:precise

ENV DEBIAN_FRONTEND noninteractive 

WORKDIR /PGSQL

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE = en_US

# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -r -g postgres --uid=999 postgres

RUN apt-get update && \
    apt-get install -y software-properties-common \
    python-software-properties apt-utils wget

RUN add-apt-repository ppa:cartodb/postgresql-9.3 && \
	add-apt-repository ppa:cartodb/pg-schema-trigger && \
	add-apt-repository ppa:cartodb/gis 

RUN apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common \
	postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 postgresql-plpython-9.3 \
	postgresql-9.3-pg-schema-triggers postgresql-9.3-plproxy proj proj-bin proj-data libproj-dev \
	libjson0 libjson0-dev python-simplejson \
	libgeos-c1v5 libgeos-dev \
	gdal-bin libgdal1-dev libgdal-dev \
	ogr2ogr2-static-bin libxml2-dev	liblwgeom-2.1.8 postgis postgresql-9.3-postgis-2.2 \
 	postgresql-9.3-postgis-scripts autoconf binutils-doc bison build-essential flex git \
    zip wget net-tools iputils-ping

# CartoDB postgresql extension
# This is the first approach, we could use a simplest and update entrypoint with a script that uses git description and get from there the lastest version
ENV CARTODB_PG_LATEST 0.11.5-g2ab0594

RUN git clone https://github.com/CartoDB/cartodb-postgresql.git && cd cartodb-postgresql && \
	git checkout $CARTODB_PG_LATEST && make all install && ldconfig

# grab gosu for easy step-down from root
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu 


ENV PG_VERSION=9.3 \
    PG_USER=postgres \
    PG_HOME=/var/lib/postgresql \
    PG_RUNDIR=/var/run/postgresql \
    PG_LOGDIR=/var/log/postgresql \
    PG_CERTDIR=/etc/postgresql/certs

ENV PG_BINDIR=/usr/lib/postgresql/${PG_VERSION}/bin

ENV PATH $PATH:$PG_BINDIR

ENV PGDATA /DATA

RUN mkdir -p /DATA && chown -R postgres:postgres $PGDATA

RUN gosu postgres initdb

RUN chmod g+s $PG_RUNDIR && \
	chown -R postgres $PG_RUNDIR && echo "local all all trust" > ${PGDATA}/pg_hba.conf && \
	echo "host all all 127.0.0.1/32 trust" >> ${PGDATA}/pg_hba.conf &&\	
	echo "host all all 0.0.0.0/0 trust" >>${PGDATA}/pg_hba.conf && \
	echo "shared_preload_libraries = 'schema_triggers.so'" >> ${PGDATA}/postgresql.conf && \
	grep -v "^listen_address"  ${PGDATA}/postgresql.conf|grep -v "^#" >${PGDATA}/postgresql_hba.conf. && \
	echo "listen_addresses = '*'" >>${PGDATA}/postgresql.conf. && \
	echo "port = 5432" >>${PGDATA}/postgresql.conf. && \
	mv ${PGDATA}/postgresql.conf. ${PGDATA}/postgresql.conf && chown -R postgres "${PGDATA}"
	
COPY docker-entrypoint.sh /


VOLUME ["${PG_RUNDIR}","${PGDATA}"]

WORKDIR ${PG_HOME}

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD [ "postgres", "first_start" ]
