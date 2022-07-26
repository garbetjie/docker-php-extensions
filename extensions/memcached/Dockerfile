ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN mkdir /usr/src/php/ext/memcached
RUN wget -O- https://pecl.php.net/get/memcached-3.2.0.tgz | tar -C /usr/src/php/ext/memcached -xzf - --strip-components 1

# Install extension.
RUN apk add libmemcached-dev zlib-dev
RUN docker-php-ext-install memcached

# Package files for extension into tar file.
RUN mkdir /tmp/docker-php-dependencies.d

RUN echo libmemcached-libs > /tmp/docker-php-dependencies.d/memcached
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini \
      /usr/local/lib/php/extensions/*-zts-*/memcached.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

