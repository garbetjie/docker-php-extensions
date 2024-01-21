ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Install
RUN apk add gettext-dev
RUN docker-php-ext-install gettext

# Package
COPY apk /docker-php-extensions/apk/gettext
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gettext.so \
      $(php-config --ini-dir)/docker-php-ext-gettext.ini \
      /docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
