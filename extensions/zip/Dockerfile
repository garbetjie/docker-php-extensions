ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Install
RUN apt-get update
RUN apt-get install -y cmake gnutls-dev libzip-dev zlib1g-dev

RUN docker-php-ext-configure zip --with-zip
RUN docker-php-ext-install zip

# Package
COPY apt /opt/docker-php-extensions/apt/zip
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/zip.so \
      $(php-config --ini-dir)/docker-php-ext-zip.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
