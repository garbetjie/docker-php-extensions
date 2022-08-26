ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install
RUN apk add bzip2-dev
RUN docker-php-ext-install bz2

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/bz2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/bz2.so \
      /usr/local/etc/php/conf.d/docker-php-ext-bz2.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
