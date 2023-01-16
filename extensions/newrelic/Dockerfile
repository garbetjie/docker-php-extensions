ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Install build dependencies.
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.15/main" >> /etc/apk/repositories
RUN apk add --no-cache git go curl-dev openssl-dev pcre-dev zlib-dev bash automake autoconf libtool $PHPIZE_DEPS \
                       binutils file fortify-headers g++ gcc=10.3.1_git20211027-r0 libc-dev make patch  # build-base packages - we need to specify gcc version

# Create working directory.
RUN mkdir /tmp/newrelic
WORKDIR /tmp/newrelic

# Get source code, and check out required version.
RUN git clone https://github.com/newrelic/newrelic-php-agent.git .
RUN git checkout v10.4.0.316

# Build extension & move files.
RUN make all
RUN strip --strip-debug agent/modules/newrelic.so && \
    mv agent/modules/newrelic.so $(php-config --extension-dir)/newrelic.so && \
    mv agent/scripts/newrelic.ini.template $(php-config --ini-dir)/docker-php-ext-newrelic.ini && \
    mv bin/daemon /usr/local/bin/newrelic-daemon

# Package files for the extension.
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

