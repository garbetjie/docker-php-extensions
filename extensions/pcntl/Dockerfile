ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Install
RUN docker-php-ext-install pcntl

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pcntl.so \
      $(php-config --ini-dir)/docker-php-ext-pcntl.ini


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
