FROM dell/lamp-base:1.2
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Set environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

# Install piwik dependencies
RUN apt-get update && apt-get install -yq \
   inotify-tools \
   php5-cli \
   php5-curl \
   php5-gd \
   php5-geoip \
   php5-json \
   unzip vim wget

# Clean package cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove any pre-installed applications
RUN rm -fr /var/www/html/*

# Get the Piwik files
RUN wget http://builds.piwik.org/piwik-2.12.1.zip
RUN unzip piwik-*.zip # files => /piwik

# Add the run script and make it executable.
COPY run.sh /run.sh
RUN chmod 755 run.sh

# Add volumes for MySQL and the application.
VOLUME ["/var/lib/mysql", "/var/www/html"]

EXPOSE 80 3306 443

CMD ["/run.sh"]
