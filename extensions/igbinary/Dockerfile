ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/igbinary
RUN curl https://pecl.php.net/get/igbinary-3.2.16.tgz | tar -C /usr/src/php/ext/igbinary -xzf - --strip-components 1

# Install
RUN docker-php-ext-install igbinary

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/igbinary.so \
      $(php-config --ini-dir)/docker-php-ext-igbinary.ini


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
