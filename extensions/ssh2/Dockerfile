ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN apk add --no-cache libssh2-dev
RUN mkdir /usr/src/php/ext/ssh2
RUN wget -O- https://pecl.php.net/get/ssh2-1.4.tgz | tar -C /usr/src/php/ext/ssh2 -xzf - --strip-components 1

# Install
RUN docker-php-ext-install ssh2

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/ssh2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/ssh2.so \
      $(php-config --ini-dir)/docker-php-ext-ssh2.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
