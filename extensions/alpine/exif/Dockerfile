ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Install
RUN docker-php-ext-install exif

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/exif.so \
      $(php-config --ini-dir)/docker-php-ext-exif.ini


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
