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