ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Install extension.
RUN apk add bzip2-dev
RUN docker-php-ext-install bz2

# Package extension.
COPY apk /tmp/docker-php-dependencies.d/apk/bz2
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-bz2.ini \
      /usr/local/lib/php/extensions/*-zts-*/bz2.so


FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

