ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Install
RUN apk add gd-dev libpng-dev libwebp-dev libjpeg-turbo-dev libxpm-dev
RUN docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype
RUN docker-php-ext-install gd

# Package
COPY apk /opt/opt/docker-php-extensions/apk/gd
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gd.so \
      $(php-config --ini-dir)/docker-php-ext-gd.ini \
      /opt/opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
