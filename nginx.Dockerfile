ARG IMAGE
FROM $IMAGE

RUN set -e; \
    apk add --no-cache nginx; \
    cd /etc/nginx; \
    rm -rf conf.d fastcgi* *.default *_params; \
    mkdir -p /var/tmp/nginx; \
    chown -R www-data:www-data /var/tmp/nginx; \
    find /var/lib -user nginx | xargs chown www-data; \
    find /var/lib -group nginx | xargs chgrp www-data;

COPY fs-nginx/ /

ENV ABSOLUTE_REDIRECT="on" \
    CONTENT_EXPIRY_DURATION="off" \
    CONTENT_EXPIRY_EXTENSIONS="js|css|png|jpg|jpeg|gif|svg|ico|ttf|woff|woff2" \
    FASTCGI_BUFFER_SIZE="64k" \
    FASTCGI_BUFFERING="on" \
    FASTCGI_BUFFERS="32 32k" \
    FASTCGI_BUSY_BUFFERS_SIZE="96k" \
    GZIP_TYPES="application/ecmascript application/javascript application/json application/xhtml+xml application/xml text/css text/ecmascript text/javascript text/plain text/xml" \
    GZIP_PROXIED="any" \
    LISTEN="/var/run/php-fpm.sock" \
    LOG_FORMAT="main" \
    PORT=80 \
    PORT_IN_REDIRECT="off" \
    ROOT="/app/public" \
    PM_STATUS_HOSTS_ALLOWED="127.0.0.1" \
    PM_STATUS_HOSTS_DENIED="all"
