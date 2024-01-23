ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/pdo_sqlsrv
RUN wget -O- https://pecl.php.net/get/pdo_sqlsrv-5.11.1.tgz | tar -C /usr/src/php/ext/pdo_sqlsrv -xzf - --strip-components 1

# Install
RUN apk add unixodbc-dev gnupg
RUN docker-php-ext-install pdo_sqlsrv

# Package
COPY apk /docker-php-extensions/apk/pdo_sqlsrv
COPY shell /docker-php-extensions/shell/pdo_sqlsrv
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pdo_sqlsrv.so \
      $(php-config --ini-dir)/docker-php-ext-pdo_sqlsrv.ini \
      /docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
