ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/apcu
RUN wget -O- https://pecl.php.net/get/apcu-5.1.21.tgz | tar -C /usr/src/php/ext/apcu -xzf - --strip-components 1

# Install
RUN docker-php-ext-install apcu

# Package
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
      /usr/local/lib/php/extensions/*-zts-*/apcu.so


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /