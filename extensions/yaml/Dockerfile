ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/yaml
RUN wget -O- https://pecl.php.net/get/yaml-2.2.3.tgz | tar -C /usr/src/php/ext/yaml -xzf - --strip-components 1

# Install
RUN apk add yaml-dev
RUN docker-php-ext-install yaml

# Package
COPY apk /opt/docker-php-extensions/apk/yaml
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/yaml.so \
      $(php-config --ini-dir)/docker-php-ext-yaml.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
