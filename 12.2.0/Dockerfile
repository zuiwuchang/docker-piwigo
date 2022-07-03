FROM ubuntu:20.04

# https://github.com/Piwigo/piwigo-videojs
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends mediainfo ffmpeg; 

RUN set -eux; \
    apt-get install -y --no-install-recommends nginx apache2; 

# php
RUN set -eux; \
    apt-get install -y --no-install-recommends php libapache2-mod-php \
    php-mysql php-apcu php-curl php-gd php-imagick \
    php-mbstring php-zip php-xml php-xmlrpc

RUN set -eux; \
    apt-get install -y --no-install-recommends curl;\
    rm -rf /var/lib/apt/lists/*;
    #apt-get install -y --no-install-recommends vim;

# * watch
RUN set -eux; \
    mkdir /opt/watch; \
    curl -k#Lo /a.tar.gz https://gitlab.com/king011/fuckccp/uploads/d9ee11b0b28f4eb09d75cdd0f7ca86e2/watch.tar.gz; \
    tar -zxvf /a.tar.gz -C /opt/watch; \
    rm /a.tar.gz;

# configure proxy env fucking ccp 
COPY cnf.tmp /cnf
RUN set -eux; \
    echo 'configure nginx'; \
    cp /cnf/nginx/nginx.conf /etc/nginx/; \
    cp /cnf/nginx/snippets /etc/nginx/ -r; \
    cp /cnf/nginx/sites-enabled/default /etc/nginx/sites-enabled/default; \
    echo 'configure apache2'; \
    cp /cnf/ports.conf /etc/apache2/; \
    echo 'watch'; \
    cp /cnf/list.json /opt/watch/list.json; \
    rm /cnf -rf;

COPY piwigo-12.2.0.tar.gz /piwigo.tar.gz
RUN set -eux; \
    rm /var/www/html -rf;

VOLUME ["/data"]

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["command-default"]