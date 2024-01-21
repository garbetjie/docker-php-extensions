ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN apk add git
RUN git clone --recursive --depth=1 https://github.com/kjdev/php-ext-snappy.git /usr/src/php/ext/snappy

# Install
RUN docker-php-ext-configure snappy
RUN docker-php-ext-install snappy

# Package
COPY apk /docker-php-extensions/apk/snappy
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/snappy.so \
      $(php-config --ini-dir)/docker-php-ext-snappy.ini \
      /docker-php-extensions

RUN ls -lah $(php-config --extension-dir)
RUN ls -lah $(php-config --ini-dir)

FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN apk add tree && tree /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
