ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Install
RUN apk add gettext-dev
RUN docker-php-ext-install gettext

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/gettext
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-gettext.ini \
      /usr/local/lib/php/extensions/*-zts-*/gettext.so


FROM php:${PHP_VERSION}-cli-alpine3.14

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /