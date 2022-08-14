ARG PHP_VERSION=8.0.8
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Install extension.
RUN docker-php-ext-install bcmath

# Package extension.
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-bcmath.ini \
      /usr/local/lib/php/extensions/*-zts-*/bcmath.so


FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /