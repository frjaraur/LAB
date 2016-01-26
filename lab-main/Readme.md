#
### CartoDB 
#
# I will use docker compose soon... when starting errors are solved ...

docker run --name pgsql lab:pgsql
docker run --name main --link pgsql:pgsql lab:main

# Debugging purposes
docker run -ti --name test --link pgsql:pgsql lab:main bash
