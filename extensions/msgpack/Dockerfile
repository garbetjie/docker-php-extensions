ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/msgpack
RUN wget -O- https://pecl.php.net/get/msgpack-2.2.0.tgz | tar -C /usr/src/php/ext/msgpack -xzf - --strip-components 1

# Install
RUN docker-php-ext-install msgpack

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/msgpack.so \
      $(php-config --ini-dir)/docker-php-ext-msgpack.ini


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
