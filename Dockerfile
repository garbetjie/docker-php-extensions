ARG SRC_TAG=""
FROM php:${SRC_TAG}

ENV NEWRELIC_VERSION="8.6.0.238" \
    OPENCENSUS_RELEASE="d1512abf456761165419a7b236e046a38b61219e"

RUN set -ex; set -o pipefail; \
    docker-php-source extract; \
    apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        gd-dev \
        libpng-dev \
        gettext-dev \
        gmp-dev \
        imap-dev \
        icu-dev \
        libxml2-dev \
        libzip-dev \
        autoconf \
        rabbitmq-c-dev \
        libmemcached-dev \
        build-base; \
    docker-php-ext-configure zip --with-libzip; \
    docker-php-ext-install \
        bcmath \
        bz2 \
        exif \
        gd \
        gettext \
        gmp \
        imap \
        intl \
        opcache \
        pdo_mysql \
        soap \
        zip; \
    pecl install \
        amqp \
        xdebug-2.7.0RC2 \
        redis \
        igbinary \
        memcached \
        msgpack; \
    apk add --no-cache \
        libzip \
        rabbitmq-c \
        libmemcached \
        libbz2 \
        libpng \
        libintl \
        icu-libs \
        gmp \
        c-client; \
    wget https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz -O- | tar -xz -C /tmp; \
        mv /tmp/newrelic-php5-*${NEWRELIC_VERSION}-linux-musl /opt/newrelic; \
        find /opt/newrelic/agent/x64 -type f ! -name "newrelic-$(php -n -i | grep -F 'PHP Extension =' | sed -e 's/PHP Extension => //').so" -delete; \
        mv "$(find /opt/newrelic/agent/x64 -iname '*.so' | head -n 1)" $(php -n -r 'echo ini_get("extension_dir");')/newrelic.so; \
        mv /opt/newrelic/daemon/newrelic-daemon.x64 /opt/newrelic/daemon.x64; \
        rm -rf /opt/newrelic/daemon /opt/newrelic/agent/ /opt/newrelic/scripts; \
    wget https://github.com/census-instrumentation/opencensus-php/archive/${OPENCENSUS_RELEASE}.tar.gz -O- | tar -C /tmp -xzf -; \
        cd /tmp/opencensus-php-*/ext; \
        phpize; \
        ./configure --enable-opencensus; \
        make; \
        echo 'n' | make test; \
        make install; \
    rm -rf /tmp/pear* /tmp/opencensus*; \
    apk del --purge .build-deps; \
    docker-php-source delete

RUN set -e; \
    docker-php-ext-enable amqp xdebug redis igbinary memcached msgpack newrelic opencensus; \
    rm -rf ${PHP_INI_DIR}/php.ini-* /usr/local/etc/php-fpm.conf.default /usr/local/etc/php-fpm.d; \
    apk add --no-cache gettext; \
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
    NEWRELIC_LABELS="" \
    NEWRELIC_LICENCE="" \
    NEWRELIC_RECORD_SQL="obfuscated" \
    SESSION_SAVE_HANDLER="files" \
    SESSION_SAVE_PATH="/tmp/sessions" \
    TIMEZONE="Etc/UTC" \
    UPLOAD_MAX_FILESIZE="8M" \
    XDEBUG_ENABLED="false" \
    XDEBUG_IDE_KEY="IDEKEY" \
    XDEBUG_REMOTE_AUTOSTART=0 \
    XDEBUG_REMOTE_HOST="192.168.99.1" \
    XDEBUG_REMOTE_PORT=9000 \
    XDEBUG_SERVER_NAME="\$server_name" \
    \
    # Generic configuration.
    TIMEOUT=60
