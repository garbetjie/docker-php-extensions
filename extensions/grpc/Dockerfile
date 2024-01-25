ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/grpc
RUN wget -O- https://pecl.php.net/get/grpc-1.60.0.tgz | tar -C /usr/src/php/ext/grpc -xzf - --strip-components 1

# Install
RUN apk add zlib-dev linux-headers binutils
RUN docker-php-ext-install grpc && strip --strip-debug /usr/local/lib/php/extensions/*-zts-*/grpc.so

# Package
COPY apk /docker-php-extensions/apk/grpc
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/grpc.so \
      $(php-config --ini-dir)/docker-php-ext-grpc.ini \
      /docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
