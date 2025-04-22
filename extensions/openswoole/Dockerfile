ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/openswoole
RUN curl https://pecl.php.net/get/openswoole-25.2.0.tgz | tar -C /usr/src/php/ext/openswoole -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y libcurl4-openssl-dev libpq-dev libssl-dev zlib1g-dev libc-ares-dev

RUN docker-php-ext-configure openswoole \
    --enable-http2 \
    --enable-mysqlnd \
    --with-postgres \
    --enable-openswoole \
    --enable-cares \
    --enable-hook-curl \
    --enable-openssl
RUN docker-php-ext-install openswoole

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/openswoole
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/openswoole.so \
      $(php-config --ini-dir)/docker-php-ext-openswoole.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
