# unitwp
NGINX Unit PHP Wordpress buildstack. This will create a docker container image, running wordpress and expose it on port 8080.


## Before you start

Get the WPCoode:
In my example I am using php composer to download the latest version of WP. The composer.json will create a folder named `wordpress` with the WP code-base in it.

run
````shell script
composer install
````

Feel free to adjust this.
In case your WP directory is different from `wordpress` adjust the Dockerfile:

YOURWPHOME = WP code-base directory

````shell script
FROM nginx/unit:1.14.0-php7.3
MAINTAINER tippexs
RUN mkdir /var/apphome/ && groupadd -r wordpress && useradd --no-log-init -r -g wordpress wordpress && \
    chown -R wordpress:wordpress /var/apphome/ && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y php7.3-mysql php7.3-gd
# Add WP CLI

COPY YOURWPHOME /var/apphome
RUN chown -R wordpress:wordpress /var/apphome/
COPY .unit.conf.json /docker-entrypoint.d/.unit.conf.json
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]
````


Adjust build.sh script to your needs:

YOURIMAGETAG = Your local image tag name
REMOTEIMAGETAG = The Image tag including the target docker registry


### Docker registry security 
NOTE: Before pushing to a private docker registry or to docker hub, you need to be logged-in.

````shell script
#!/usr/bin/env bash
set -ex
build_container() {
  docker build -t YOURIMAGETAG --no-cache .
}

containerize() {
  echo "Building Container Image"
  build_container
  docker tag YOURIMAGETAG:latest REMOTEIMAGETAG:latest
  echo "Pushing... "
  docker push REMOTEIMAGETAG:latest
}

case $1 in
"push")
  echo "Building and Pushing to Registry ..."
  containerize
  ;;
esac
````


##Using Environment-Variables
It is never a good idea or practise to store sensitive credentials inside your repository. Let's use an example to make it clear:
Set the database connection information for your wordpress site using environment variables.

Environent variables can be set
 - While starting the container instance (https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file)
 - Using a docker-compose file (https://docs.docker.com/compose/environment-variables/)
 - Using the NGINX Unit config or the NGINX Unit API to specify them.
 
Example of NGINX Unit configuration with environments:
NOTE: If you want to push your Unit configuration to git, do not store passwords here. Use the dynamic reconfiguration methods instead
(https://unit.nginx.org/configuration/#quick-start)


````json
  "applications": {
    "application": {
      "type": "php",
      "options": {
        "file": "/etc/php.ini",
        "admin": {
          "upload_max_filesize": "20M"
        }
      },
      "environment": {
        "DB_HOST": "mariadb",
        "SOMETHING": "else"
      },
      "user": "wordpress",
      "group": "wordpress",
      "root": "/var/apphome"
    }
  }
````

To access your variables (e.g. in your wp-config.php) you can simply use something like:
````php
<?php
    /** The name of the database for WordPress */
    define('DB_NAME', isset ($_ENV['DB_NAME']) ? $_ENV['DB_NAME'] : 'database');
    
    /** MySQL database username */
    define('DB_USER',  isset ($_ENV['DB_USER']) ? $_ENV['DB_USER'] : 'user');
    
    /** MySQL database password */
    define('DB_PASSWORD', isset ($_ENV['DB_PASSWORD']) ? $_ENV['DB_PASSWORD'] : 'password');
    
    /** MySQL hostname */
    define('DB_HOST', isset ($_ENV['DB_HOST']) ? $_ENV['DB_HOST'] : 'localhost' );
````

