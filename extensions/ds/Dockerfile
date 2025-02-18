ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/ds
RUN curl https://pecl.php.net/get/ds-1.5.0.tgz | tar -C /usr/src/php/ext/ds -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure ds
RUN docker-php-ext-install ds

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/ds.so \
      $(php-config --ini-dir)/docker-php-ext-ds.ini


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
