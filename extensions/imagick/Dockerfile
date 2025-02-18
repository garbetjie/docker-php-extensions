ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/imagick
RUN curl https://pecl.php.net/get/imagick-3.7.0.tgz | tar -C /usr/src/php/ext/imagick -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y libmagick++-dev
RUN docker-php-ext-install imagick

# Package
COPY apt /opt/docker-php-extensions/apt/imagick
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/imagick.so \
      $(php-config --ini-dir)/docker-php-ext-imagick.ini \
      /opt/docker-php-extensions


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
