#!/bin/bash
set -e

ERRORS=0

ACTION=$1
ENVIRONMENT=$2

export RAILS_ENV=$ENVIRONMENT

# I will prepare cleaner case structure ...  :|

[ "$ACTION" = 'help' ] && echo "Help should be here :)"


if [ "$ACTION" = 'start_all' -o "$1" = 'first_start' ];then

	echo "Starting REDIS Server" 
	/usr/bin/redis-server /REDIS/redis.conf
	echo

	cd /CARTODB/cartodb
		
	if [ "$ACTION" = 'first_start' -a ! -f /CARTODB/setup_finished ];then
	
		echo "First RUN ...."
	
		echo "Starting DB:MIGRATE ...."
		bundle exec rake db:migrate --trace && ERRORS=$(( ERRORS + 1 ))
		echo
		
		
		echo "Starting DB:SETUP ...."	
		bundle exec rake db:setup --trace && ERRORS=$(( ERRORS + 1 ))
		echo 
		
		
		#[ $ERRORS -ne 0 ] && echo "ERRORS during first run... can not start CartoDB..." && exit 1 		
	
		touch /CARTODB/setup_finished
	fi
	
	[ ! -f /CARTODB/setup_finished ] && "First Run container with 'first_start' " && exit 1
	

	
	echo "Staring Ruby On Rails Server ...."
	bundle exec rails server -d
	echo
	
	echo "Starting resque ...."
	nohup bundle exec script/resque > /tmp/resque.out 2>&1&
	echo
	
	
	if [ "$1" = 'first_start' ];then
		export SUBDOMAIN=development
		
		export PASSWORD="changeme"
		export ADMIN_PASSWORD="changeme"
		export EMAIL="admin@dummy.me"
		
		echo "PASSWORD: $PASSWORD"
		echo "ADMIN_PASSWORD: $ADMIN_PASSWORD"
		echo "EMAIL: $EMAIL"
		
	    # Add entries to /etc/hosts needed in development
		[ $(grep -c "${SUBDOMAIN}" /etc/hosts ) -eq 0 ] && echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | tee -a /etc/hosts
		
	   
		echo "Creating Development User ...."
		bundle exec rake cartodb:db:create_dev_user --trace SUBDOMAIN="${SUBDOMAIN}" \
		PASSWORD="${PASSWORD}" ADMIN_PASSWORD="${ADMIN_PASSWORD}" \
		EMAIL="${EMAIL}"
	fi
	
	echo "Starting CARTODB ...."			
	bundle exec thin start --threaded -p 3000 --threadpool-size 5
	echo 
		
	echo "Starting SQL API ...."
	/usr/bin/node /CARTODB/CartoDB-SQL-API/app.js &
	echo
	
	
	echo "Starting MAPS API ...."
	/usr/bin/node /CARTODB/Windshaft-cartodb/app.js &
	echo 
	
	
else

	exec "$@"
fi	

