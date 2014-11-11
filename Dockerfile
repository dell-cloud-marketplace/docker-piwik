FROM dell/lamp-base:1.0
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Ensure UTF-8
RUN apt-get update
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update

# Install piwik dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install inotify-tools
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-json
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unzip
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget

ADD run.sh /run.sh
RUN chmod 755 run.sh

# Remove any pre-installed applications
RUN rm -fr /var/www/html/*

# Get the Piwik files
RUN mkdir -p /app
RUN cd /app && \
    wget http://builds.piwik.org/piwik-2.8.3.zip && \
    unzip -q piwik-2.8.3.zip && \
    mv piwik/* . && \
    rm -r piwik && \
    rm piwik-2.8.3.zip

# Add volumes for MySQL and the application.
VOLUME ["/var/lib/mysql", "/var/www/html"]

EXPOSE 80 3306 443

CMD ["/run.sh"]
