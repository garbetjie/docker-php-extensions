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
COPY fs/ /
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pdo_sqlsrv.so \
      /usr/local/etc/php/conf.d/docker-php-ext-pdo_sqlsrv.ini \
      /tmp/docker-php-dependencies.d


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
