#!/bin/bash
set -e
o
echo "starting slapd"
/usr/sbin/slapd -h "ldap:///" -u openldap -g openldap -d 0
service supervisor start
echo "Load default ldap domain ... [cartodb.com] "
ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/backend.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_load.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_config.ldif
ldapadd -x -D cn=admin,dc=cartodb,dc=com -w changeme -c -f /tmp/objects.ldif

echo "Remember to change admin initial password 'changeme' ... "

echo
echo "Starting own command ..."
echo
exec "$@"

