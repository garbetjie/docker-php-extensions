ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Install
RUN apk add gmp-dev
RUN docker-php-ext-install gmp

# Package
COPY apk /opt/docker-php-extensions/apk/gmp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gmp.so \
      $(php-config --ini-dir)/docker-php-ext-gmp.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
