ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/pdo_sqlsrv
RUN wget -O- https://pecl.php.net/get/pdo_sqlsrv-5.10.1.tgz | tar -C /usr/src/php/ext/pdo_sqlsrv -xzf - --strip-components 1

# Install
RUN apk add unixodbc-dev gnupg
RUN docker-php-ext-install pdo_sqlsrv

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/pdo_sqlsrv
COPY shell /tmp/docker-php-dependencies.d/shell/pdo_sqlsrv
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini \
      /usr/local/lib/php/extensions/*-zts-*/pdo_sqlsrv.so


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /

