ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN apk add --no-cache libssh2-dev
RUN mkdir /usr/src/php/ext/ssh2
RUN wget -O- https://pecl.php.net/get/ssh2-1.3.1.tgz | tar -C /usr/src/php/ext/ssh2 -xzf - --strip-components 1

# Install
RUN docker-php-ext-install ssh2

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/ssh2
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-ssh2.ini \
      /usr/local/lib/php/extensions/*-zts-*/ssh2.so


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /