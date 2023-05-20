ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Install
RUN apk add gettext-dev
RUN docker-php-ext-install gettext

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/gettext
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gettext.so \
      $(php-config --ini-dir)/docker-php-ext-gettext.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /
