FROM  ubuntu:trusty

MAINTAINER FRJARAUR "frjaraur@gmail.com"

ENV LC_ALL C 
ENV DEBIAN_FRONTEND noninteractive 

RUN groupadd -r openldap && useradd -r -g openldap openldap

RUN apt-get update && \
	echo "slapd slapd/root_password changeme password" |debconf-set-selections && \
	echo "slapd slapd/root_password_again changeme password" |debconf-set-selections && \
	echo "slapd slapd/internal/adminpw changeme password" |debconf-set-selections && \
	echo "slapd slapd/internal/generated_adminpw changeme password" |debconf-set-selections && \
	echo "slapd slapd/password2 changeme password" |debconf-set-selections && \
	echo "slapd slapd/password1 changeme password" |debconf-set-selections && \
	echo "slapd slapd/domain string cartodb.com" |debconf-set-selections && \
	echo "slapd shared/organization string cartodb" |debconf-set-selections && \
	echo "slapd slapd/backend string HDB" |debconf-set-selections && \
	echo "slapd slapd/purge_database boolean true" |debconf-set-selections && \
	echo "slapd slapd/move_old_database boolean true" |debconf-set-selections && \
	echo "slapd slapd/allow_ldap_v2 boolean false" |debconf-set-selections && \
	echo "slapd slapd/no_configuration boolean false" |debconf-set-selections && \
	apt-get install -y slapd ldap-utils supervisor &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ldapfiles/backend.ldif /tmp/backend.ldif
COPY ldapfiles/sssvlv_load.ldif /tmp/sssvlv_load.ldif
COPY ldapfiles/sssvlv_config.ldif /tmp/sssvlv_config.ldif
COPY ldapfiles/objects.ldif /tmp/objects.ldif
COPY ldapfiles/supervisord.conf /etc/supervisord.conf
#RUN	ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/backend.ldif
#RUN	ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_load.ldif
#RUN ldapadd -Y EXTERNAL -H ldapi:/// -f /tmp/sssvlv_config.ldif
#RUN ldapadd -x -D cn=admin,dc=cartodb,dc=com -w changeme -c -f /tmp/objects.ldif
    
#Add more users in more_users.ldif    
# ldapadd -x -D cn=admin,dc=home,dc=lab -w passwordless -c -f more_users.ldif


# Set OpenLDAP data and config directories in a data volume
VOLUME ["/var/lib/ldap", "/etc/ldap/slapd.d"]

EXPOSE 389
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "bash" ]
