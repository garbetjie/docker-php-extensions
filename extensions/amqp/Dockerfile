ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/amqp
RUN wget -O- https://pecl.php.net/get/amqp-1.11.0.tgz | tar -C /usr/src/php/ext/amqp -xzf - --strip-components 1

# Install
RUN apk add rabbitmq-c-dev
RUN docker-php-ext-install amqp

# Package
COPY apk /docker-php-extensions/apk/amqp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/amqp.so \
      $(php-config --ini-dir)/docker-php-ext-amqp.ini \
      /docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
