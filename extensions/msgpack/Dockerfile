ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/msgpack
RUN wget -O- https://pecl.php.net/get/msgpack-2.1.2.tgz | tar -C /usr/src/php/ext/msgpack -xzf - --strip-components 1

# Install
RUN docker-php-ext-install msgpack

# Package
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-msgpack.ini \
      /usr/local/lib/php/extensions/*-zts-*/msgpack.so


FROM php:${PHP_VERSION}-cli-alpine3.14

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /