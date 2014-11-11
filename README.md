# docker-piwik

This image installs [Piwik][piwik] 2.8.3 an open source web analytics platform. 

[piwik]: https://piwik.org/

## Components

The stack comprises the following components (some are obtained through [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                   | Description
-----------|---------------------------|------------------------------
Piwik      | 2.8.3                     | Web analytics platform
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)                    | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)      | Scripting language

## Usage
### 1. Image Creation

Build the Piwik image with the tag `dell/piwik`:

    sudo docker build -t dell/piwik .


### 2. Container Creation / Running

#### A. Basic Usage
Start your container with:
 - Ports 80 (Apache Web Server) and 3306 (MySQL) exposed.
 - A named container (**piwik**).
 - A MySQL user **admin** with a random password
 
```no-highlight

    sudo docker run -d --name="piwik" \
             -e MYSQL_PASS="$(pwgen -s -1 16)" \
             -p 80:80 \
             -p 3306:3306 \
             dell/piwik
```

#### B. Advanced Usage
Start your container with:
 - Ports 80 (Apache Web Server) and 3306 (MySQL) exposed.
 - A named container (**piwik**).
 - A MySQL user **admin**  with a predefined password: "password"
 - Two data volumes (which will survive a restart or recreation of the container). The MySQL data is available in **/data/mysql** on the host. The PHP application files are available in **/app** on the host.

As follows: 


    sudo docker run -d --name="piwik" \
             -v /app:/var/www/html \
             -v /data/mysql:/var/lib/mysql \
             -e MYSQL_PASS="password"  \
             -p 80:80 \
             -p 3306:3306 \
             dell/piwik


### 3. Connecting to the Database


If you haven't defined a password, the container will generate a random
one.  
Check the logs for the randomly generated MySQL password by running: 

     sudo docker logs piwik

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -p<password> -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
```


MySQL admin credentials will be needed when configuring Piwik the first time.

Next, you can test the admin connection to MySQL:

    mysql -uadmin -p<password> -h127.0.0.1 -P3306


### 4. Configure Piwik
Access the container from your browser:

    http://<ip address>

#### Step 1: Welcome to Piwik's Installation Wizard!
Click Next to proceed with the installation.
Click Next after System check.
.
#### Step 2: Set up the database
Complete the required information:

* Database Server : **127.0.0.1**
* Login: **admin**
* Password: **admin_password**. *The MySQL admin password read from the logs*
* Database Name : **Enter a database name**. *This database will store Piwik information*
* Tables Prefix: **_piwik**
* Adapter: **MYSQL/PDO** 

Click Next, Make sure tables were created successfully and click Next again.

#### Step 3: Set up the Piwik super user

The super user is the user that you create when you install Piwik. 
This user has the highest permissions. Choose your username and password:

Do not lose this information; it is the only way for you to log in to Piwik for the first time. There is only one super user in each Piwik installation. The super user can perform administrative tasks such as adding new websites to monitor, adding users, changing user permissions, and enabling and disabling plugins.

By default the super user will be signed up for upgrade and security alerts, as well as for community updates. Uncheck these boxes if you do not want to receive these emails.

Fill in the information and click Next.

#### Step 4: Set up Your First Website

Enter the name and URL of the first website you want to track. 
You can add more websites once the installation is complete.

Piwik will issue you with a JavaScript tag. This code must appear on every page that you want Piwik to analyze. We recommend that you put this code just before your tag at the bottom of your pages (or in a general footer file that is included at the bottom of all your pages).

When you have copied your tracking tag click Next.

#### Step 5: Congratulation, Piwik is installed!

Piwik is installed and ready to track your visitors. 
You are redirected to the login page. Login in with the Piwik super user credentials. 

As soon as visitors start arriving, Piwik will be keeping track of their data. Piwik reports are generated in real time, so you should see data in your Piwik dashboard straight away.

## Reference

### Image Details

Inspired by [bprodoehl/piwik](https://github.com/bprodoehl/docker-piwik-mariadb)

Pre-built Image | [https://registry.hub.docker.com/u/dell/piwik](https://registry.hub.docker.com/u/dell/piwik) 
