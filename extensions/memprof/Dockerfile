ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/memprof
RUN curl https://pecl.php.net/get/memprof-3.0.2.tgz | tar -C /usr/src/php/ext/memprof -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y libjudy-dev
RUN docker-php-ext-install memprof

# Package
COPY apt /opt/docker-php-extensions/apt/memprof
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/memprof.so \
      $(php-config --ini-dir)/docker-php-ext-memprof.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
