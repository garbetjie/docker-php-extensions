ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/uopz
RUN wget -O- https://pecl.php.net/get/uopz-7.1.1.tgz | tar -C /usr/src/php/ext/uopz -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure uopz --enable-uopz
RUN docker-php-ext-install uopz

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/uopz.so \
      $(php-config --ini-dir)/docker-php-ext-uopz.ini


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
