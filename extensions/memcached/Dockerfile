ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/memcached
RUN wget -O- https://pecl.php.net/get/memcached-3.2.0.tgz | tar -C /usr/src/php/ext/memcached -xzf - --strip-components 1

# Install
RUN apk add libmemcached-dev zlib-dev
RUN docker-php-ext-configure memcached --enable-memcached-session --enable-memcached-sasl
RUN docker-php-ext-install memcached

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/memcached
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/memcached.so \
      /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
