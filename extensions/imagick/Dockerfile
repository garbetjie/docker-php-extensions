ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/imagick
RUN wget -O- https://pecl.php.net/get/imagick-3.7.0.tgz | tar -C /usr/src/php/ext/imagick -xzf - --strip-components 1

# Install
RUN apk add imagemagick-dev
RUN docker-php-ext-install imagick

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/imagick
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/imagick.so \
      $(php-config --ini-dir)/docker-php-ext-imagick.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
