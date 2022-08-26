ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install
RUN apk add gd-dev libpng-dev libwebp-dev libjpeg-turbo-dev libxpm-dev
RUN docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype
RUN docker-php-ext-install gd

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/gd
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gd.so \
      /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
