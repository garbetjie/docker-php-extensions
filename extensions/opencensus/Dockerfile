ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/opencensus
RUN wget -O- https://pecl.php.net/get/opencensus-0.3.0.tgz | tar -C /usr/src/php/ext/opencensus -xzf - --strip-components 1

# Install
RUN docker-php-ext-install opencensus

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/opencensus.so \
      $(php-config --ini-dir)/docker-php-ext-opencensus.ini


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
