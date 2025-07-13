ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/apcu
RUN curl https://pecl.php.net/get/apcu-5.1.24.tgz | tar -C /usr/src/php/ext/apcu -xzf - --strip-components 1

# Install
RUN docker-php-ext-install apcu

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-ext-install-deps \
      $(php-config --extension-dir)/apcu.so \
      $(php-config --ini-dir)/docker-php-ext-apcu.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
