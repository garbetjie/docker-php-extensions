ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install
RUN apk add icu-dev
RUN docker-php-ext-install intl

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/intl
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/intl.so \
      /usr/local/etc/php/conf.d/docker-php-ext-intl.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
