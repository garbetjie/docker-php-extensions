ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/swoole
RUN wget -O- https://pecl.php.net/get/swoole-5.1.4.tgz | tar -C /usr/src/php/ext/swoole -xzf - --strip-components 1

# Install
RUN apk add openssl-dev curl-dev sqlite-dev postgresql-dev
RUN docker-php-ext-configure swoole  \
    --enable-brotli \
    --enable-cares \
    --enable-mysqlnd \
    --enable-openssl \
    --enable-swoole \
    --enable-swoole-curl \
    --enable-swoole-pgsql \
    --enable-swoole-sqlite
RUN docker-php-ext-install swoole

# Package
COPY apk /docker-php-extensions/apk/swoole
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/swoole.so \
      $(php-config --ini-dir)/docker-php-ext-swoole.ini \
      /docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
