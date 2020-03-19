# ************* DEV DOCKER FILE *************
FROM nginx/unit:1.14.0-php7.3
MAINTAINER timo.stark@nginx.com
RUN mkdir /var/apphome/ && groupadd -r wordpress && useradd --no-log-init -r -g wordpress wordpress && \
    chown -R wordpress:wordpress /var/apphome/ && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y php7.3-mysql php7.3-gd && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    cp wp-cli.phar /usr/local/bin/wpc

COPY php.ini /etc/php/7.3/cli/conf.d/php-unit.ini
COPY .unit.conf.json /docker-entrypoint.d/.unit.conf.json
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]