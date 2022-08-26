ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Install
RUN apk add cmake gnutls-dev libzip-dev libretls-dev zlib-dev
RUN docker-php-ext-configure zip --with-zip
RUN docker-php-ext-install zip

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/zip
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/zip.so \
      /usr/local/etc/php/conf.d/docker-php-ext-zip.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
