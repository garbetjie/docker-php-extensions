ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/redis
RUN wget -O- https://pecl.php.net/get/redis-5.3.7.tgz | tar -C /usr/src/php/ext/redis -xzf - --strip-components 1

# Install
RUN apk add zstd-dev
RUN docker-php-ext-install redis

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/redis
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/redis.so \
      /usr/local/etc/php/conf.d/docker-php-ext-redis.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
