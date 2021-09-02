ARG PHP_VERSION=8.0
FROM php:${PHP_VERSION}-apache-bullseye


FROM debian:bullseye-slim
COPY --from=0 /etc/apt/preferences.d/no-debian-php /etc/apt/preferences.d/no-debian-php

# Apache config.
COPY --from=0 /etc/apache2/conf-available/docker-php.conf /etc/apache2/conf-available/docker-php.conf
COPY --from=0 /etc/apache2/mods-available/php.load /etc/apache2/mods-available/php.load

# PHP module
COPY --from=0 /usr/lib/apache2/modules/libphp.so /usr/lib/apache2/modules/libphp.so

# PHP source.
COPY --from=0 /usr/src/php* /usr/src/

# Bin files.
COPY --from=0 /usr/local/bin/docker-* /usr/local/bin/php* /usr/local/bin/

# Config
COPY --from=0 /usr/local/etc/php /usr/local/etc/php

COPY --from=0 /usr/local/include/php /usr/local/include/php
COPY --from=0 /usr/local/lib/php /usr/local/lib/php
COPY --from=0 /usr/local/php /usr/local/php

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-suggests --no-install-recommends \
        apache2 \
        ca-certificates  \
        curl \
        dash \
        libargon2-0 \
        libedit2 \
        libonig5 \
        libreadline8 \
        libsodium23 \
        libsqlite3-0 \
        libxml2 \
        xz-utils \
        zlib1g; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/cache/debconf /var/log/dpkg.log /var/log/apt /var/www

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" \
    PHP_CPPFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64" \
    PHP_EXTRA_BUILD_DEPS="apache2-dev" \
    PHP_EXTRA_CONFIGURE_ARGS="--with-apxs2 --disable-cgi" \
    PHP_INI_DIR="/usr/local/etc/php" \
    PHP_LDFLAGS="-Wl,-O1 -pie" \
    PHP_VERSION="$PHP_VERSION" \
    PHPIZE_DEPS="autoconf dpkg-dev file g++ gcc libc-dev make pkg-config re2c"

COPY bin/docker-custom-ext-install /usr/local/bin/

# Install gRPC separately.
RUN docker-custom-ext-install grpc-1.38.0

# Install the other extensions.
RUN set -ex; \
    docker-custom-ext-install \
        amqp-1.11.0beta \
        bcmath \
        bz2 \
        exif \
        gd \
        gettext \
        gmp \
        igbinary-3.2.3 \
        imagick-3.5.0 \
        imap \
        intl \
        memcached-3.1.5 \
        msgpack-2.1.2 \
        opcache \
        opencensus-0.3.0 \
        pcntl \
        pdo_mysql \
        protobuf-3.17.3 \
        redis-5.3.4 \
        soap \
        sockets \
        xdebug-3.0.4 \
        yaml-2.2.1 \
        zip

COPY fs/ /
COPY fs-apache/ /

RUN set -ex; \
    a2dismod mpm_*; \
    a2enmod mpm_prefork headers; \
    rm -rf /etc/apache2/sites-*

ENV APACHE_DOCUMENT_ROOT="/srv" \
    APACHE_LOG_LEVEL="warn" \
    APACHE_TRACE_ENABLE="Off" \
    APACHE_START_SERVERS=0

ENV DISPLAY_ERRORS="Off" \
    ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    EXPOSE_PHP=false \
    HTML_ERRORS="Off" \
    MAX_EXECUTION_TIME=30 \
    MAX_INPUT_TIME=30 \
    MAX_REQUEST_SIZE="8M" \
    MEMORY_LIMIT="64M" \
    NEWRELIC_ENABLED=false \
    NEWRELIC_APPNAME="" \
    NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT=true \
    NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT=5 \
    NEWRELIC_DAEMON_LOGLEVEL="error" \
    NEWRELIC_DAEMON_ADDRESS="@newrelic-daemon" \
    NEWRELIC_DAEMON_START_TIMEOUT=3 \
    NEWRELIC_LABELS="" \
    NEWRELIC_LICENCE="" \
    NEWRELIC_LOGLEVEL="warning" \
    NEWRELIC_PROCESS_HOST_DISPLAY_NAME="" \
    NEWRELIC_TRANSACTION_TRACER_RECORD_SQL="obfuscated" \
    OPCACHE_ENABLED=true \
    OPCACHE_CLI_ENABLED=true \
    OPCACHE_PRELOAD="" \
    OPCACHE_MAX_ACCELERATED_FILES=10000 \
    OPCACHE_REVALIDATE_FREQ=2 \
    OPCACHE_VALIDATE_TIMESTAMPS=true \
    OPCACHE_SAVE_COMMENTS=true \
    OPENCENSUS_ENABLED=false \
    PARALLEL_ENABLED=false \
    SESSION_COOKIE_NAME="PHPSESSID" \
    SESSION_SAVE_HANDLER="files" \
    SESSION_SAVE_PATH="/tmp/sessions" \
    SYS_TEMP_DIR="/tmp" \
    TIMEZONE="Etc/UTC" \
    UPLOAD_MAX_FILESIZE="8M" \
    XDEBUG_ENABLED=false \
    XDEBUG_IDEKEY="IDEKEY" \
    XDEBUG_CLIENT_HOST="host.docker.internal" \
    XDEBUG_CLIENT_PORT=9003

RUN apt-get update && apt-get install -y gawk && apt-get clean && mkdir -p /docker-entrypoint.d
RUN mkdir -p /var/run/apache2
RUN a2disconf '*'
RUN a2enmod php
ENTRYPOINT ["/docker-entrypoint.sh"]