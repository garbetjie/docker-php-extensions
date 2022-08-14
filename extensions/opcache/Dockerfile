ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Install
RUN docker-php-ext-install opcache

# Package
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
      /usr/local/lib/php/extensions/*-zts-*/opcache.so


FROM php:${PHP_VERSION}-cli-alpine3.14

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /