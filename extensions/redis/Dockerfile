ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/redis
RUN wget -O- https://pecl.php.net/get/redis-6.0.2.tgz | tar -C /usr/src/php/ext/redis -xzf - --strip-components 1

# Install
RUN apk add zstd-dev
RUN docker-php-ext-install redis

# Package
COPY apk /docker-php-extensions/apk/redis
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/redis.so \
      $(php-config --ini-dir)/docker-php-ext-redis.ini \
      /docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
