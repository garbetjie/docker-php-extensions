ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/apcu
RUN wget -O- https://pecl.php.net/get/apcu-5.1.24.tgz | tar -C /usr/src/php/ext/apcu -xzf - --strip-components 1

# Install
RUN docker-php-ext-install apcu

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/apcu.so \
      $(php-config --ini-dir)/docker-php-ext-apcu.ini


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
