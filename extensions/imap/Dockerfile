ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Install
RUN apk add krb5-dev imap-dev libretls-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/imap
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-imap.ini \
      /usr/local/lib/php/extensions/*-zts-*/imap.so


FROM php:${PHP_VERSION}-cli-alpine3.14

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /

