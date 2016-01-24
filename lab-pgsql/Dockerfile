FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

WORKDIR /CARTODB

ENV SERVICEINSTALL WORKDIR

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget


## POSTGRESQL
    
RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common \
	postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 postgresql-plpython-9.3    
  
RUN add-apt-repository ppa:cartodb/pg-schema-trigger && apt-get update && \
	apt-get install -y postgresql-9.3-pg-schema-triggers

# Change PostgreSQL pg_hba.conf, everything else is the PostgreSQL default config
ADD servicefiles/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD servicefiles/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
RUN chown -R postgres /etc/postgresql/9.3/main


# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Restart PostreSQL for security changes to take effect 
RUN service postgresql restart

# Create CartoDB users
ADD servicefiles servicefiles
RUN chmod -R 755 servicefiles
ENTRYPOINT ["servicefiles/cartodb_create_users.sh"]

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
 	
	
ENTRYPOINT ["servicefiles/cartodb_postgis.sh"]


RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	


# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]


