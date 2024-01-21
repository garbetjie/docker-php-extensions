ARG PHP_VERSION
ARG ALPINE_VERSION=3.18
FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

ARG ALPINE_VERSION

# Run the 3.16 installation.
RUN if [ "$ALPINE_VERSION" = "3.16" ]; then \
      echo "https://dl-cdn.alpinelinux.org/alpine/v3.15/main" >> /etc/apk/repositories; \
      apk add git go curl-dev openssl-dev pcre-dev zlib-dev bash automake autoconf libtool $PHPIZE_DEPS \
                  binutils file fortify-headers g++ gcc=10.3.1_git20211027-r0 libc-dev make patch; \
    fi

# Run the > 3.16 installation.
RUN if [ "$ALPINE_VERSION" != "3.16" ]; then \
      apk add git go curl-dev openssl-dev pcre-dev zlib-dev bash automake autoconf libtool $PHPIZE_DEPS \
                  binutils file fortify-headers g++ gcc libc-dev make patch; \
    fi

# Create working directory.
RUN mkdir /tmp/newrelic
WORKDIR /tmp/newrelic

# Get source code, and check out required version.
RUN git clone https://github.com/newrelic/newrelic-php-agent.git .
RUN git checkout v10.9.0.324

# Build extension & move files.
RUN make all
RUN strip --strip-debug agent/modules/newrelic.so && \
    mv agent/modules/newrelic.so $(php-config --extension-dir)/newrelic.so && \
    mv agent/scripts/newrelic.ini.template $(php-config --ini-dir)/docker-php-ext-newrelic.ini && \
    mv bin/daemon /usr/local/bin/newrelic-daemon

# Package files for the extension.
COPY apk /docker-php-extensions/apk/newrelic
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/newrelic.so \
      $(php-config --ini-dir)/docker-php-ext-newrelic.ini \
      /docker-php-extensions \
      /usr/local/bin/newrelic-daemon


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /

