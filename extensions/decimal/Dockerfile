ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/decimal
RUN wget -O- https://pecl.php.net/get/decimal-1.5.0.tgz | tar -C /usr/src/php/ext/decimal -xzf - --strip-components 1

# Install
RUN apk add mpdecimal-dev
RUN docker-php-ext-install decimal

# Package
COPY apk /opt/docker-php-extensions/apk/decimal
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/decimal.so \
      $(php-config --ini-dir)/docker-php-ext-decimal.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
