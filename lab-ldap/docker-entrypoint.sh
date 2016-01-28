#!/bin/bash
set -e

if [ "$1" = "slapd" ]
then
	echo "starting slapd"
	#service supervisor stop
	service slapd restart
	ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/backend.ldif
	ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_load.ldif
	ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_config.ldif
	ldapadd -x -D cn=admin,dc=cartodb,dc=com -w changeme -c -f /tmp/objects.ldif
	

	/usr/sbin/slapd -h "ldap:///" -u openldap -g openldap -d 0
	service supervisor start
else

	exec "$@"
fi	

