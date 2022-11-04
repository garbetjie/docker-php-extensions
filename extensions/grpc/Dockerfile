ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/grpc
RUN wget -O- https://pecl.php.net/get/grpc-1.48.0.tgz | tar -C /usr/src/php/ext/grpc -xzf - --strip-components 1

# Install
RUN apk add zlib-dev linux-headers binutils
RUN docker-php-ext-install grpc && strip --strip-debug /usr/local/lib/php/extensions/*-zts-*/grpc.so

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/grpc
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/grpc.so \
      $(php-config --ini-dir)/docker-php-ext-grpc.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
