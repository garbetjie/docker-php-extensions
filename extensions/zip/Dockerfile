ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Install
RUN apk add cmake gnutls-dev libzip-dev libretls-dev zlib-dev
RUN docker-php-ext-configure zip --with-zip
RUN docker-php-ext-install zip

# Package
COPY apk /opt/docker-php-extensions/apk/zip
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/zip.so \
      $(php-config --ini-dir)/docker-php-ext-zip.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
