ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN docker-php-ext-install pcntl

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-ext-install-deps \
      $(php-config --extension-dir)/pcntl.so \
      $(php-config --ini-dir)/docker-php-ext-pcntl.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
