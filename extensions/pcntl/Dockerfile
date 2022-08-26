ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install
RUN docker-php-ext-install pcntl

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pcntl.so \
      /usr/local/etc/php/conf.d/docker-php-ext-pcntl.ini


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
