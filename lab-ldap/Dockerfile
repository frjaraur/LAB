FROM  ubuntu:trusty

MAINTAINER FRJARAUR "frjaraur@gmail.com"

ENV LC_ALL C 
ENV DEBIAN_FRONTEND noninteractive 

RUN groupadd -r openldap && useradd -r -g openldap openldap

RUN apt-get update && \
	echo 'slapd/root_password password changeme' | debconf-set-selections &&\
    echo 'slapd/root_password_again password changeme' | debconf-set-selections &&
	apt-get install -y slapd ldap-utils &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ldapfiles /ldapfiles


RUN service slapd start ;\
    cd /ldapfiles &&\
	ldapadd -Y EXTERNAL -H ldapi:/// -f backend.ldif &&\
	ldapadd -Y EXTERNAL -H ldapi:/// -f sssvlv_load.ldif &&\
    ldapadd -Y EXTERNAL -H ldapi:/// -f sssvlv_config.ldif &&\
    ldapadd -x -D cn=admin,dc=test,dc=cartodb -w changeme -c -f objects.ldif
    
#Add more users in more_users.ldif    
# ldapadd -x -D cn=admin,dc=home,dc=lab -w passwordless -c -f more_users.ldif





# Set OpenLDAP data and config directories in a data volume
VOLUME ["/var/lib/ldap", "/etc/ldap/slapd.d"]

EXPOSE 389

CMD slapd -h 'ldap:/// ldapi:///' -g openldap -u openldap -F /etc/ldap/slapd.d -d stats
