ARG IMAGE
FROM $IMAGE

RUN set -ex -o pipefail; \
    \
    # Set up useful variables for the build environment.
    ZTS="$(if [ "$(php -ni 2>&1 | grep -iF 'Thread Safety' | grep -iF 'enabled')" != "" ]; then printf true; else printf false; fi)"; \
    ZTS_SUFFIX="$(if [ "$ZTS" = true ]; then printf '-zts'; else printf ''; fi)"; \
    PHP_VERSION="$(php -nv | grep -E -o 'PHP [0-9]+\.[0-9]+' | cut -f2 -d' ')"; \
    NEWRELIC_VERSION="9.11.0.267"; \
    OS="$(. /etc/os-release; printf "%s" "$ID")"; \
    php_version_in() { while [ $# -gt 0 ]; do if [ "$PHP_VERSION" = "$1" ]; then return 0; fi; shift; done; return 1; }; \
    download_ext() { rm -rf "/usr/src/php/ext/$1"; mkdir -p "/usr/src/php/ext/$1"; curl -L "$2" | tar -xz --strip-components 1 -C "/usr/src/php/ext/$1"; }; \
    download_pecl_ext() { download_ext "$1" "https://pecl.php.net/get/$1-$2.tgz"; }; \
    docker-php-source extract; \
    \
    # Add build dependencies.
    apk add --no-cache --virtual .build-deps \
        autoconf \
        build-base \
        bzip2-dev \
        gd-dev \
        gettext-dev \
        gmp-dev \
        icu-dev \
        imap-dev \
        libjpeg-turbo-dev \
        libmemcached-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        libzip-dev \
        rabbitmq-c-dev \
        tar; \
    \
    # Download extensions.
    download_pecl_ext amqp 1.10.2; \
    download_pecl_ext igbinary 3.1.2; \
    download_pecl_ext memcached 3.1.5; \
    download_pecl_ext msgpack 2.1.0; \
    download_pecl_ext redis 5.3.0; \
    download_pecl_ext xdebug 3.0.2; \
    download_ext newrelic "https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz"; \
    if php_version_in 7.2 7.3 7.4; then \
        download_ext opencensus "https://github.com/census-instrumentation/opencensus-php/archive/007b35d8f7ed21cab9aa47406578ae02f73f91c5.tar.gz"; \
        [[ "$ZTS" = true ]] && download_ext parallel "https://github.com/krakjoe/parallel/archive/ebc3cc8e61cbfdb049cb7951b4df31cd336a9b18.tar.gz"; \
        \
        docker-php-ext-configure opencensus/ext; \
    fi; \
    \
    # Configure extensions
    if php_version_in 7.4 8.0; then \
        docker-php-ext-configure zip; \
        docker-php-ext-configure gd --with-jpeg --with-webp; \
    else \
        docker-php-ext-configure zip --with-libzip; \
        docker-php-ext-configure gd --with-jpeg-dir=/usr/lib --with-webp-dir=/usr/lib; \
    fi; \
    \
    # Install extensions.
    docker-php-ext-install -j5 \
        bcmath \
        bz2 \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        memcached \
        opcache \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        xdebug \
        zip; \
    if php_version_in 7.2 7.3 7.4; then \
        [[ "$ZTS" = true ]] && docker-php-ext-install parallel; \
        docker-php-ext-install -j5 \
            amqp \
            igbinary \
            msgpack \
            opencensus/ext \
            redis; \
            \
            # Install New Relic.
            mkdir -p /opt/newrelic; \
            find /usr/src/php/ext/newrelic/agent/x64 -type f ! -name "newrelic-$(php -n -i | grep -F 'PHP Extension =' | sed -e 's/PHP Extension => //')${ZTS_SUFFIX}.so" -delete; \
            mv "$(find /usr/src/php/ext/newrelic/agent/x64 -iname '*.so' | head -n 1)" $(php -n -r 'echo ini_get("extension_dir");')/newrelic.so; \
            mv /usr/src/php/ext/newrelic/daemon/newrelic-daemon.x64 /opt/newrelic/daemon.x64; \
    fi; \
    \
    # Add runtime depedencies.
    apk add --no-cache \
        c-client \
        dash \
        dumb-init \
        gettext \
        gmp \
        icu-libs \
        libbz2 \
        libintl \
        libjpeg \
        libmemcached \
        libpng \
        libwebp \
        libzip \
        runit \
        rabbitmq-c \
        socat; \
    \
    # Remove build dependencies.
    rm -rf /tmp/pear*; \
    apk del --purge .build-deps; \
    docker-php-source delete

# Run cleanup of configuration files.
RUN set -e; \
    rm -rf ${PHP_INI_DIR}/php.ini-* /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d; \
    mkdir -p /var/log/newrelic; \
    mkdir /app && chown www-data:www-data /app; \
    mkdir -p /docker-entrypoint.d

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
WORKDIR /app

COPY fs/ /

# Remove the extensions that aren't available on < 8.0.
RUN \
    if [ "$(php -nv | grep -E -o 'PHP [0-9]+\.[0-9]+' | cut -f2 -d' ')" = "8.0" ]; then \
        rm "$PHP_INI_DIR/conf.d/docker-php-ext-newrelic.ini"; \
    fi

ENV \
    # FPM-specific configuration.
    PM="static" \
    LISTEN="0.0.0.0:9000" \
    MAX_CHILDREN=0 \
    MIN_SPARE_SERVERS=1 \
    MAX_SPARE_SERVERS=3 \
    MAX_REQUESTS=10000 \
    STATUS_PATH="/_fpm/status" \
    TIMEOUT=60 \
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
    NEWRELIC_ENABLED="false" \
    NEWRELIC_APP_NAME="" \
    NEWRELIC_AUTORUM_ENABLED=0 \
    NEWRELIC_DAEMON_LOGLEVEL="error" \
    NEWRELIC_DAEMON_PORT="@newrelic-daemon" \
    NEWRELIC_DAEMON_WAIT=5 \
    NEWRELIC_HOST_DISPLAY_NAME="" \
    NEWRELIC_LABELS="" \
    NEWRELIC_LICENCE="" \
    NEWRELIC_LOGLEVEL="warning" \
    NEWRELIC_RECORD_SQL="obfuscated" \
    OPCACHE_ENABLED=true \
    OPCACHE_CLI_ENABLED=true \
    OPCACHE_MAX_ACCELERATED_FILES=10000 \
    OPCACHE_REVALIDATE_FREQ=2 \
    OPCACHE_VALIDATE_TIMESTAMPS=true \
    OPCACHE_SAVE_COMMENTS=true \
    OPENCENSUS_ENABLED=true \
    PARALLEL_ENABLED=false \
    SESSION_COOKIE_NAME="PHPSESSID" \
    SESSION_SAVE_HANDLER="files" \
    SESSION_SAVE_PATH="/tmp/sessions" \
    SYS_TEMP_DIR="/tmp" \
    TIMEZONE="Etc/UTC" \
    UPLOAD_MAX_FILESIZE="8M" \
    XDEBUG_ENABLED="false" \
    XDEBUG_IDEKEY="IDEKEY" \
    XDEBUG_CLIENT_HOST="host.docker.internal" \
    XDEBUG_CLIENT_PORT=9003
