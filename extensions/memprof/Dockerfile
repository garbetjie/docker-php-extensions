ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-alpine

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/memprof
RUN wget -O- https://pecl.php.net/get/memprof-3.0.2.tgz | tar -C /usr/src/php/ext/memprof -xzf - --strip-components 1

# Install
RUN apk add judy-dev bsd-compat-headers
RUN docker-php-ext-install memprof

# Package
COPY apk /opt/docker-php-extensions/apk/memprof
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/memprof.so \
      $(php-config --ini-dir)/docker-php-ext-memprof.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-alpine

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
