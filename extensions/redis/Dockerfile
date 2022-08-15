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
RUN mkdir /tmp/docker-php-dependencies.d
RUN echo zstd-libs > /tmp/docker-php-dependencies.d/redis
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-redis.ini \
      /usr/local/lib/php/extensions/*-zts-*/redis.so


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /