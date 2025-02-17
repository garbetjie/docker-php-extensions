ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Install
RUN apk add bzip2-dev
RUN docker-php-ext-install bz2

# Package
COPY apk /opt/docker-php-extensions/apk/bz2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/bz2.so \
      $(php-config --ini-dir)/docker-php-ext-bz2.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
