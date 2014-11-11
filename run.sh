#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

sed -i -e 's/^bind-address/#bind-address/' /etc/mysql/my.cnf

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini
if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

#If the application directory is empty, copy the site.
APPLICATION_HOME="/var/www/html"

if [ ! "$(ls -A $APPLICATION_HOME)" ]; then
    # Copy the application folder.
    cp -r /app/* $APPLICATION_HOME
    # Configure permissions.
    chmod a+w $APPLICATION_HOME/config $APPLICATION_HOME/tmp
fi

exec supervisord -n
