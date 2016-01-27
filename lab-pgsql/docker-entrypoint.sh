#!/bin/bash
set -e


if [ "$1" = 'postgres' ]; then
	if [ "$2" = "first_start" -a ! -f ${PGDATA}/first_start_done ]
	then
			echo "Opening database Locally for some work ..."
			
			gosu postgres pg_ctl -D "${PGDATA}" -o "-c listen_addresses=''" -w start
			
			gosu postgres createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres
			
			gosu postgres createuser tileuser --no-createrole --no-createdb --no-superuser -U postgres
			
			gosu postgres createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
			
			#gosu postgres createlang plpgsql -U postgres -d template_postgis
			
			gosu postgres psql -U postgres template_postgis -c 'CREATE OR REPLACE LANGUAGE plpgsql;'
			
			gosu postgres psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;'
			
			echo "Stopping Database For a Complete Start ... "
			
			gosu postgres pg_ctl -D "${PGDATA}" -m fast -w stop
			
			touch ${PGDATA}/first_start_done
			
	fi	
			
			echo "Starting PostgreSQL..."
  			
  			exec start-stop-daemon --start --chuid ${PG_USER}:${PG_USER} \
   			--exec ${PG_BINDIR}/postgres -- -D ${PGDATA} 
			
			
else

	exec "$@"
fi	

