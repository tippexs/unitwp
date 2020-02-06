FROM nginx/unit:1.14.0-php7.3
MAINTAINER tippexs
RUN mkdir /var/apphome/ && groupadd -r wordpress && useradd --no-log-init -r -g wordpress wordpress && \
    chown -R wordpress:wordpress /var/apphome/ && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y php7.3-mysql php7.3-gd

COPY wordpress /var/apphome
RUN chown -R wordpress:wordpress /var/apphome/
COPY .unit.conf.json /docker-entrypoint.d/.unit.conf.json
CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]