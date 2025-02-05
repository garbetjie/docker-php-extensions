ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

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
COPY apk /docker-php-extensions/apk/memcached
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/memcached.so \
      $(php-config --ini-dir)/docker-php-ext-memcached.ini \
      /docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
