ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN mkdir /usr/src/php/ext/xdebug
RUN wget -O- https://pecl.php.net/get/xdebug-3.1.5.tgz | tar -C /usr/src/php/ext/xdebug -xzf - --strip-components 1

# Install extension.
# RUN docker-php-ext-configure xdebug
RUN docker-php-ext-install xdebug

# Package files for extension into tar file.
RUN tar -cf /tmp/files.tar \
      /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      /usr/local/lib/php/extensions/*-zts-*/xdebug.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

