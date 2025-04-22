ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/memcached
RUN curl https://pecl.php.net/get/memcached-3.3.0.tgz | tar -C /usr/src/php/ext/memcached -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y libmemcached-dev zlib1g-dev libssl-dev
RUN docker-php-ext-configure memcached --enable-memcached-session --enable-memcached-sasl
RUN docker-php-ext-install memcached

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/memcached
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/memcached.so \
      $(php-config --ini-dir)/docker-php-ext-memcached.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
