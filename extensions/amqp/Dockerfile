ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/amqp
RUN wget -O- https://pecl.php.net/get/amqp-1.11.0.tgz | tar -C /usr/src/php/ext/amqp -xzf - --strip-components 1

# Install
RUN apk add rabbitmq-c-dev
RUN docker-php-ext-install amqp

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/amqp
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-amqp.ini \
      /usr/local/lib/php/extensions/*-zts-*/amqp.so


FROM php:${PHP_VERSION}-cli-alpine3.14

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /