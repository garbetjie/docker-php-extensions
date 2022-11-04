ARG PHP_VERSION=8.0.8
FROM php:${PHP_VERSION}-cli-alpine3.15

# Install build dependencies.
RUN apk add --no-cache binutils git go build-base curl-dev openssl-dev pcre-dev zlib-dev bash automake autoconf libtool $PHPIZE_DEPS

# Create working directory.
RUN mkdir /tmp/newrelic
WORKDIR /tmp/newrelic

# Get source code, and check out required version.
RUN git clone https://github.com/newrelic/newrelic-php-agent.git .
RUN git checkout v10.0.0.312

# Build extension & move files.
RUN make all
RUN strip --strip-debug agent/modules/newrelic.so && \
    mv agent/modules/newrelic.so $(php-config --extension-dir)/newrelic.so && \
    mv agent/scripts/newrelic.ini.template $(php-config --ini-dir)/docker-php-ext-newrelic.ini && \
    mv bin/daemon /usr/local/bin/newrelic-daemon

# Set some defaults in the INI file.
WORKDIR /usr/local/etc/php/conf.d
RUN sed -i '/;newrelic.enabled = true/c\newrelic.enabled = true' docker-php-ext-newrelic.ini
RUN sed -i '/newrelic.logfile = /c\newrelic.logfile = "/proc/1/fd/2"' docker-php-ext-newrelic.ini
RUN sed -i '/newrelic.daemon.logfile = /c\newrelic.daemon.logfile = "/proc/1/fd/2"' docker-php-ext-newrelic.ini
RUN sed -i '/;newrelic.daemon.location = /c\newrelic.daemon.location = "/usr/local/bin/newrelic-daemon"' docker-php-ext-newrelic.ini
RUN sed -i '/;newrelic.error_collector.record_database_errors = /c\newrelic.error_collector.record_database_errors = true' docker-php-ext-newrelic.ini

# Package files for the extension.
#RUN echo libbz2 libcurl libedit libjpeg-turbo libmcrypt libpng readline tidyhtml-libs libltdl libxml2 libxslt openssl pcre zlib
COPY apk /tmp/docker-php-dependencies.d/apk/newrelic
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/newrelic.so \
      $(php-config --ini-dir)/docker-php-ext-newrelic.ini \
      /tmp/docker-php-dependencies.d \
      /usr/local/bin/newrelic-daemon


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


FROM scratch

COPY --from=1 /tmp/root /

