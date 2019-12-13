ARG SRC_TAG=""
FROM php:${SRC_TAG}

RUN ZTS_ENABLED="$(php -ni 2>&1 | grep -qiF 'Thread Safety => enabled' && printf true || printf false)"; \
    ZTS_SUFFIX="$(if [ $ZTS_ENABLED = true ]; then printf '-zts'; else printf ''; fi)"; \
    PHP_VERSION="$(php -nv | grep -E -o 'PHP [0-9]+\.[0-9]+' | cut -f2 -d' ')"; \
    NEWRELIC_VERSION="9.4.1.250"; \
    if test "$PHP_VERSION" = "7.4"; then \
        OPENCENSUS_SRC_URL="https://github.com/garbetjie/opencensus-php/archive/failing-tests-7.4.tar.gz"; \
    else \
        OPENCENSUS_SRC_URL="https://github.com/census-instrumentation/opencensus-php/archive/d1512abf456761165419a7b236e046a38b61219e.tar.gz"; \
    fi; \
    set -ex; set -o pipefail; \
    docker-php-source extract; \
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
        libxml2-dev \
        libzip-dev \
        rabbitmq-c-dev; \
    docker-php-ext-configure zip --with-libzip; \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/lib; \
    docker-php-ext-install -j5 \
        bcmath \
        bz2 \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        opcache \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        zip; \
    pecl install \
        amqp \
        xdebug-2.8.0 \
        redis \
        igbinary \
        memcached \
        msgpack; \
    if [ "$ZTS_ENABLED" = true ]; then \
        pecl install parallel; \
    fi; \
    apk add --no-cache \
        c-client \
        gettext \
        gmp \
        icu-libs \
        libbz2 \
        libintl \
        libjpeg \
        libmemcached \
        libpng \
        libzip \
        rabbitmq-c; \
    wget "$OPENCENSUS_SRC_URL" -O- | tar -C /tmp -xzf -; \
        cd /tmp/opencensus-php-*/ext; \
        phpize; \
        ./configure --enable-opencensus; \
        make; \
        echo 'n' | make test; \
        make install; \
    wget https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz -O- | tar -xz -C /tmp; \
        mv /tmp/newrelic-php5-*${NEWRELIC_VERSION}-linux-musl /opt/newrelic; \
        find /opt/newrelic/agent/x64 -type f ! -name "newrelic-$(php -n -i | grep -F 'PHP Extension =' | sed -e 's/PHP Extension => //')${ZTS_SUFFIX}.so" -delete; \
        mv "$(find /opt/newrelic/agent/x64 -iname '*.so' | head -n 1)" $(php -n -r 'echo ini_get("extension_dir");')/newrelic.so; \
        mv /opt/newrelic/daemon/newrelic-daemon.x64 /opt/newrelic/daemon.x64; \
        rm -rf /opt/newrelic/daemon /opt/newrelic/agent/ /opt/newrelic/scripts; \
    docker-php-ext-enable \
		amqp \
		igbinary \
		memcached \
		msgpack \
		newrelic \
		opencensus \
		redis \
		xdebug; \
    if [ "$ZTS_ENABLED" = true ]; then \
        docker-php-ext-enable parallel; \
    fi; \
    rm -rf /tmp/pear* /tmp/opencensus*; \
    apk del --purge .build-deps; \
    docker-php-source delete

# Run cleanup of configuration files..
RUN set -e; \
    rm -rf ${PHP_INI_DIR}/php.ini-* /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d; \
    mkdir -p /var/log/newrelic; \
    mkdir /app && chown www-data:www-data /app

ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR /app

COPY fs/ /

ENV \
    # FPM-specific configuration.
    PM="static" \
    MAX_CHILDREN=0 \
    MIN_SPARE_SERVERS=1 \
    MAX_SPARE_SERVERS=3 \
    MAX_REQUESTS=10000 \
    STATUS_PATH="/_/status" \
    TIMEOUT=60 \
    \
    # PHP-specific configuration.
    DISPLAY_ERRORS="Off" \
    ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
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
    NEWRELIC_DAEMON_WAIT=3 \
    NEWRELIC_HOST_DISPLAY_NAME="" \
    NEWRELIC_LABELS="" \
    NEWRELIC_LICENCE="" \
    NEWRELIC_RECORD_SQL="obfuscated" \
    OPENCENSUS_ENABLED="false" \
    SESSION_COOKIE_NAME="PHPSESSID" \
    SESSION_SAVE_HANDLER="files" \
    SESSION_SAVE_PATH="/tmp/sessions" \
    TIMEZONE="Etc/UTC" \
    UPLOAD_MAX_FILESIZE="8M" \
    XDEBUG_ENABLED="false" \
    XDEBUG_IDE_KEY="IDEKEY" \
    XDEBUG_REMOTE_AUTOSTART=0 \
    XDEBUG_REMOTE_HOST="192.168.99.1" \
    XDEBUG_REMOTE_PORT=9000
