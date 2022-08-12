ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN apk add --no-cache libssh2-dev
RUN mkdir /usr/src/php/ext/ssh2
RUN wget -O- https://pecl.php.net/get/ssh2-1.3.1.tgz | tar -C /usr/src/php/ext/ssh2 -xzf - --strip-components 1

# Install extension.
RUN docker-php-ext-configure ssh2
RUN docker-php-ext-install ssh2

# Package files for extension into tar file.
RUN mkdir /tmp/docker-php-dependencies.d
RUN echo libssh2 > /tmp/docker-php-dependencies.d/ssh2
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-ssh2.ini \
      /usr/local/lib/php/extensions/*-zts-*/ssh2.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

