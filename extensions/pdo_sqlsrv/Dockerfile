ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN mkdir /usr/src/php/ext/pdo_sqlsrv
RUN wget -O- https://pecl.php.net/get/pdo_sqlsrv-5.10.1.tgz | tar -C /usr/src/php/ext/pdo_sqlsrv -xzf - --strip-components 1

# Install extension.
RUN apk add unixodbc-dev
RUN docker-php-ext-install pdo_sqlsrv

# Package files for extension into tar file.
RUN mkdir /tmp/docker-php-dependencies.d
RUN echo unixodbc libstdc++ > /tmp/docker-php-dependencies.d/pdo_sqlsrv
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini \
      /usr/local/lib/php/extensions/*-zts-*/pdo_sqlsrv.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

