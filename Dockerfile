ARG SOURCE_IMAGE
FROM $SOURCE_IMAGE AS variant

COPY bin/docker-replace-apk-repository /usr/local/bin/

# Because the gRPC extension takes so long to compile, it's better to do it as a separate step to make better use of the
# layer caching. We also strip out debugging symbols, as the .so file is over 100MB otherwise.
RUN set -ex; \
    docker-replace-apk-repository "https://pkg.adfinis.com/alpine/v3.14"; \
    docker-php-source extract; \
    rm -rf "/usr/src/php/ext/grpc"; \
    mkdir "/usr/src/php/ext/grpc"; \
    wget -q -O- "https://pecl.php.net/get/grpc-1.38.0.tgz" | tar -xz --strip-components 1 -C "/usr/src/php/ext/grpc"; \
    apk add --no-cache --virtual .build-deps linux-headers binutils zlib-dev; \
    docker-php-ext-install -j2 grpc; \
    docker-php-source delete; \
    \
    xargs strip --strip-debug "$(php -n -r 'echo ini_get("extension_dir");')/grpc.so"; \
    apk del --no-cache .build-deps; \
    docker-replace-apk-repository;

# Copy in bin files.
COPY bin/docker-custom-ext-* /usr/local/bin/

# Install everything else.
RUN set -ex; \
    docker-replace-apk-repository "https://pkg.adfinis.com/alpine/v3.14"; \
    docker-php-source extract; \
    docker-custom-ext-download \
        amqp:1.10.2 \
        igbinary:3.2.3 \
        imagick:3.5.0 \
        memcached:3.1.5 \
        msgpack:2.1.2 \
        newrelic:https://download.newrelic.com/php_agent/archive/9.17.1.301/newrelic-php5-9.17.1.301-linux-musl.tar.gz \
        opencensus:0.3.0 \
        protobuf:3.17.3 \
        redis:5.3.4 \
        yaml:2.2.1 \
        xdebug:3.0.4; \
    docker-custom-ext-install \
        amqp \
        bcmath \
        bz2 \
        exif \
        gd \
        gettext \
        gmp \
        igbinary \
        imagick \
        imap \
        intl \
        memcached \
        msgpack \
        newrelic \
        opcache \
        opencensus \
        pcntl \
        pdo_mysql \
        protobuf \
        redis \
        soap \
        sockets \
        xdebug \
        yaml \
        zip; \
    docker-php-source delete; \
    docker-replace-apk-repository "https://pkg.adfinis.com/alpine/v3.14";

# Run cleanup of configuration files.
RUN set -e; \
    rm -rf ${PHP_INI_DIR}/php.ini-* /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d; \
    mkdir -p /var/log/newrelic; \
    mkdir /app && chown www-data:www-data /app; \
    mkdir -p /docker-entrypoint.d

ENTRYPOINT ["tini", "/docker-entrypoint.sh"]
WORKDIR /app

COPY fs/ /

# Global configuration.
ENV ENABLED_EXTENSIONS="" \
    DISABLED_EXTENSIONS="newrelic opencensus xdebug"

# Composer config {{{
ENV COMPOSER_VERSION="2.1.11" \
    COMPOSER_CHECKSUM="69af1f5a6fe76256293cf341af43399a4d7d4c4336235b2dd4553ee9" \
    COMPOSER_VERIFY_CHECKSUM="true"
# }}}

ENV \
    # FPM-specific configuration.
    PM="static" \
    LISTEN="0.0.0.0:9000" \
    PM_MAX_CHILDREN=0 \
    PM_MIN_SPARE_SERVERS=1 \
    PM_MAX_SPARE_SERVERS=3 \
    PM_MAX_REQUESTS=10000 \
    PM_STATUS_PATH="/_fpm/status" \
    REQUEST_TERMINATE_TIMEOUT=60 \
    REQUEST_SLOWLOG_TIMEOUT=0 \
    SLOWLOG="/proc/self/fd/2" \
    \
    # PHP-specific configuration.
    DISPLAY_ERRORS="Off" \
    ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    EXPOSE_PHP=false \
    HTML_ERRORS="Off" \
    MAX_EXECUTION_TIME=30 \
    MAX_INPUT_TIME=30 \
    MAX_REQUEST_SIZE="8M" \
    MEMORY_LIMIT="64M" \
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
    SESSION_COOKIE_NAME="PHPSESSID" \
    SESSION_SAVE_HANDLER="files" \
    SESSION_SAVE_PATH="/tmp/sessions" \
    SYS_TEMP_DIR="/tmp" \
    TIMEZONE="Etc/UTC" \
    UPLOAD_MAX_FILESIZE="8M" \
    XDEBUG_IDEKEY="IDEKEY" \
    XDEBUG_CLIENT_HOST="host.docker.internal" \
    XDEBUG_CLIENT_PORT=9003

FROM variant AS nginx

RUN set -e; \
    apk add --no-cache nginx; \
    cd /etc/nginx; \
    rm -rf conf.d fastcgi* *.default *_params; \
    mkdir -p /var/tmp/nginx; \
    chown -R www-data:www-data /var/tmp/nginx; \
    find /var/lib -user nginx | xargs chown www-data; \
    find /var/lib -group nginx | xargs chgrp www-data;

COPY fs-nginx/ /

ENV ABSOLUTE_REDIRECT="on" \
    CONTENT_EXPIRY_DURATION="off" \
    CONTENT_EXPIRY_EXTENSIONS="js|css|png|jpg|jpeg|gif|svg|ico|ttf|woff|woff2" \
    FASTCGI_BUFFER_SIZE="64k" \
    FASTCGI_BUFFERING="on" \
    FASTCGI_BUFFERS="32 32k" \
    FASTCGI_BUSY_BUFFERS_SIZE="96k" \
    GZIP_TYPES="application/ecmascript application/javascript application/json application/xhtml+xml application/xml text/css text/ecmascript text/javascript text/plain text/xml" \
    GZIP_PROXIED="any" \
    LISTEN="/var/run/php-fpm.sock" \
    LOG_FORMAT="main" \
    PORT=80 \
    PORT_IN_REDIRECT="off" \
    ROOT="/app/public" \
    PM_STATUS_HOSTS_ALLOWED="127.0.0.1" \
    PM_STATUS_HOSTS_DENIED="all"
