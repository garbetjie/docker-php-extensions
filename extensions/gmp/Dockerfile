ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Install
RUN apk add gmp-dev
RUN docker-php-ext-install gmp

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/gmp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gmp.so \
      $(php-config --ini-dir)/docker-php-ext-gmp.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
