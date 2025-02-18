ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

ARG ALPINE_VERSION

# Run the > 3.16 installation.
RUN apt-get update
RUN apt-get install -y \
    git \
    golang-go \
    libcurl4-openssl-dev \
    libssl-dev \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    bash \
    automake \
    autoconf \
    libtool \
    $PHPIZE_DEPS \
    binutils \
    file \
    build-essential \
    patch \
    libprotobuf-dev

#RUN apk add git go curl-dev openssl-dev pcre-dev zlib-dev bash automake autoconf libtool $PHPIZE_DEPS \
#            binutils file fortify-headers g++ gcc libc-dev make patch protobuf-c protobuf-c-dev

# Create working directory.
RUN mkdir /tmp/newrelic
WORKDIR /tmp/newrelic

# Get source code, and check out required version.
RUN git clone https://github.com/newrelic/newrelic-php-agent.git .
RUN git checkout v10.16.0.5

# Build extension & move files.
RUN make all
RUN strip --strip-debug agent/modules/newrelic.so && \
    mv agent/modules/newrelic.so $(php-config --extension-dir)/newrelic.so && \
    mv agent/scripts/newrelic.ini.template $(php-config --ini-dir)/docker-php-ext-newrelic.ini && \
    mv bin/daemon /usr/local/bin/newrelic-daemon

# Package files for the extension.
COPY apt /opt/docker-php-extensions/apt/newrelic
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/newrelic.so \
      $(php-config --ini-dir)/docker-php-ext-newrelic.ini \
      /opt/docker-php-extensions \
      /usr/local/bin/newrelic-daemon


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /

