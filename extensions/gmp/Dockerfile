ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install
RUN apk add gmp-dev
RUN docker-php-ext-install gmp

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/gmp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gmp.so \
      /usr/local/etc/php/conf.d/docker-php-ext-gmp.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
