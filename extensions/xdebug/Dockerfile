ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/xdebug
RUN curl https://pecl.php.net/get/xdebug-3.4.1.tgz | tar -C /usr/src/php/ext/xdebug -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y linux-headers-generic
RUN docker-php-ext-install xdebug

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/xdebug.so \
      $(php-config --ini-dir)/docker-php-ext-xdebug.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

# Debugging of arch.
RUN file /tmp/root$(php-config --extension-dir)/xdebug.so
RUN arch


FROM scratch

COPY --from=1 /tmp/root /
