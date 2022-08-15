ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/xdebug
RUN wget -O- https://pecl.php.net/get/xdebug-3.1.5.tgz | tar -C /usr/src/php/ext/xdebug -xzf - --strip-components 1

# Install
RUN docker-php-ext-install xdebug

# Package
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      /usr/local/lib/php/extensions/*-zts-*/xdebug.so


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /