#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

# Possibly invoke the inherited script.
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

APPLICATION_HOME="/var/www/html"

# If the application directory is empty, copy the site.
if [ ! "$(ls -A $APPLICATION_HOME)" ]; then
    # Copy the application folder.
    cp -r /piwik/. $APPLICATION_HOME

    # Configure ownership.
    chown -R www-data:www-data $APPLICATION_HOME/tmp
    chown -R www-data:www-data $APPLICATION_HOME/config
fi

exec supervisord -n
