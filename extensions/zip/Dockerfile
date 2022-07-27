ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Install extension.
RUN apk add cmake gnutls-dev libzip-dev libretls-dev zlib-dev
RUN docker-php-ext-configure zip --with-zip
RUN docker-php-ext-install zip

# Package files for extension into tar file.
RUN mkdir /tmp/docker-php-dependencies.d

RUN echo libzip > /tmp/docker-php-dependencies.d/zip
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-zip.ini \
      /usr/local/lib/php/extensions/*-zts-*/zip.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

