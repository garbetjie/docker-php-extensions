ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/sqlsrv
RUN wget -O- https://pecl.php.net/get/sqlsrv-5.12.0.tgz | tar -C /usr/src/php/ext/sqlsrv -xzf - --strip-components 1

# Install
RUN apk add unixodbc-dev gnupg
RUN docker-php-ext-install sqlsrv

# Package
COPY apk /opt/docker-php-extensions/apk/sqlsrv
COPY shell /opt/docker-php-extensions/shell/sqlsrv
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/sqlsrv.so \
      $(php-config --ini-dir)/docker-php-ext-sqlsrv.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
