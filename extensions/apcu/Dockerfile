ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN mkdir /usr/src/php/ext/apcu
RUN wget -O- https://pecl.php.net/get/apcu-5.1.21.tgz | tar -C /usr/src/php/ext/apcu -xzf - --strip-components 1

# Install extension.
RUN docker-php-ext-install apcu

# Package files for extension into tar file.
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
      /usr/local/lib/php/extensions/*-zts-*/apcu.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

