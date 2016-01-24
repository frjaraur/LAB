FROM  ubuntu:precise

MAINTAINER FRJARAUR "frjaraur@gmail.com"

WORKDIR /CARTODB

ENV CARTODBINSTALL WORKDIR

RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
    autoconf binutils-doc bison build-essential flex git python-software-properties libpango1.0-dev \
    libreadline6-dev openssl python-all-dev imagemagick unp zip wget



RUN add-apt-repository ppa:cartodb/postgresql-9.3 && apt-get update && \
	apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common    


## PIP
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py
## RUBY

RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
	tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0 && make install
	
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
RUN gem install bundler &&  gem install compass


## EDITOR



RUN apt-get install -y libicu-dev
RUN git clone --recursive https://github.com/CartoDB/cartodb.git && cd cartodb && RAILS_ENV=development bundle install

## NODEJS
RUN add-apt-repository ppa:cartodb/nodejs-010 && apt-get update && apt-get -y install nodejs

WORKDIR /CARTODB/cartodb

RUN	npm install

RUN add-apt-repository ppa:cartodb/gis && apt-get update && \
	apt-get install -y gdal-bin libgdal1-dev libgdal-dev
	
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

RUN pip install --no-use-wheel -r python_requirements.txt

ENV PATH $PATH:$CARTODBINSTALL/cartodb/node_modules/grunt-cli/bin

RUN bundle install && bundle exec node_modules/grunt-cli/bin/grunt --environment development

COPY config/app_config.yml config/app_config.yml
COPY config/database.yml config/database.yml

#RUN cp config/app_config.yml.sample config/app_config.yml && cp config/database.yml.sample config/database.yml	

ENV RAILS_ENV development

ENTRYPOINT ["bundle", "exec"]

#RUN service redis-server restart && 
#RUN RAILS_ENV=development bundle exec rake db:migrate
#RUN service redis-server restart && 
#RUN RAILS_ENV=development bundle exec rake db:setup

CMD ["rake","db:migrate"]


	
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*	
