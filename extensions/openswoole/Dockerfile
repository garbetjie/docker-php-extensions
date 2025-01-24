ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/openswoole
RUN curl https://pecl.php.net/get/openswoole-22.1.2.tgz | tar -C /usr/src/php/ext/openswoole -xzf - --strip-components 1

# Install
RUN apt update
RUN apt install -y libcurl4-openssl-dev libpq-dev libssl-dev zlib1g-dev libc-ares-dev

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
COPY apt /opt/docker-php-extensions/apt/openswoole
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/openswoole.so \
      $(php-config --ini-dir)/docker-php-ext-openswoole.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
