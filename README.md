# docker-piwik

This image installs [Piwik](https://piwik.org), an open-source web analytics platform. 

## Components

The stack comprises the following components (some are obtained through [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base)):

Name       | Version                   | Description
-----------|---------------------------|------------------------------
Piwik      | 2.8.3                     | Web analytics platform
Ubuntu     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Operating system
MySQL      | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Database
Apache     | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Web server
PHP        | see [docker-lamp-base](https://github.com/dell-cloud-marketplace/docker-lamp-base) | Scripting language

## Usage

### 1. Start the Container

#### A. Basic Usage

Start your container with:

* Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed
* A named container (**piwik**)

As follows: 

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 -p 3306:3306 --name piwik dell/piwik
```

#### B. Advanced Usage

Start your container with:

* Ports 80, 443 (Apache Web Server) and 3306 (MySQL) exposed
* A named container (**piwik**)
* A predefined password for the MySQL **admin** user
* Two data volumes (which will survive a restart or recreation of the container). The MySQL data is available in **/data/mysql** on the host. The PHP application files are available in **/app** on the host

As follows: 

```no-highlight
sudo docker run -d \
    -p 80:80 \
    -p 443:443 \
    -p 3306:3306 \
    -v /app:/var/www/html \
    -v /data/mysql:/var/lib/mysql \
    -e MYSQL_PASS="password"  \
    --name piwik \
    dell/piwik
```

### 2. Check the Log Files

If you haven't defined a MySQL password, the container will generate a random one. Check the logs for the password by running: 

     sudo docker logs piwik

You will see output like the following:

```no-highlight
========================================================================
You can now connect to this MySQL Server using:

    mysql -uadmin -pca1w7dUhnIgI -h<host> -P<port>

Please remember to change the above password as soon as possible!
MySQL user 'root' has no password but only allows local connections
========================================================================
```

In this case, **ca1w7dUhnIgI** is the password allocated to the admin user. You will need these credentials when configuring Piwik for the first time. Test the admin connection to MySQL, as follows, substituting your password: 

    mysql -uadmin -pca1w7dUhnIgI -h127.0.0.1 -P3306


### 3. Configure Piwik
Access the container from your browser:

    http://<ip address>
    
OR
 
    https://<ip address>

**We strongly recommend that you connect via HTTPS**, for this step, and all subsequent administrative tasks, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

#### Step 1: Welcome!
Click **Next** to proceed with the installation.

#### Step 2: System Check
Click **Next**.

#### Step 3: Database Setup
Complete the required information:

* Database Server : **127.0.0.1**
* Login: **admin**
* Password: *The password read from the logs OR your predefined password*
* Database Name : **piwik**
* Tables Prefix: **piwik_**
* Adapter: **MYSQL/PDO** 

Click **Next**.

#### Step 4: Creating the Tables
Verify that the tables were created successfully. Click **Next**.

#### Step 5: Super User
The super user is the user that you create when you install Piwik. This user has the highest permissions, and can perform administrative tasks such as adding new websites to monitor, adding users, changing user permissions, and enabling and disabling plugins.

Choose your username and password. Do not lose this information; it is the only way for you to log in to Piwik for the first time.

By default, the super user will be signed up for upgrade and security alerts, as well as for community updates. Uncheck these boxes if you do not want to receive these emails.

Fill in the information and click **Next**.

#### Step 6: Setup a Website
Enter or select the values for the web site you want to track:

* website name
* website URL
* website time zone
* Ecommerce

Note that you can add more websites once the installation is complete.

Click **Next**.

#### Step 7: JavaScript Tracking Code

Piwik will issue you with a JavaScript tag, such as the following:

```no-highlight
<!-- Piwik -->
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//54.75.168.125/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', 1]);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js';
    s.parentNode.insertBefore(g,s);
  })();
</script>
<noscript><p><img src="//54.75.168.125/piwik.php?idsite=1" style="border:0;"
  alt="" /></p></noscript>
<!-- End Piwik Code -->
```

This code must appear on every page that you want Piwik to analyze. We recommend that you put this code just before your tag at the bottom of your pages (or in a general footer file that is included at the bottom of all your pages).

When you have copied your tracking tag click **Next**.

#### Step 8: Congratulations

Piwik is installed and ready to track your visitors. You are redirected to the login page. Login in with the Piwik super user credentials. 

As soon as visitors start arriving, Piwik will be keeping track of their data. Piwik reports are generated in real time, so you should see data in your Piwik dashboard straight away.

Click on **Continue to Piwik**.

## Reference

### Image Details

Inspired by [bprodoehl/piwik](https://github.com/bprodoehl/docker-piwik-mariadb)

Pre-built Image | [https://registry.hub.docker.com/u/dell/piwik](https://registry.hub.docker.com/u/dell/piwik) 
