ARG SRC_TAG=""
FROM php:${SRC_TAG}

ENV NEWRELIC_VERSION="8.5.0.235" \
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

RUN docker-php-ext-enable amqp xdebug redis igbinary memcached msgpack newrelic opencensus
