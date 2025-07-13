ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN apt-get update
RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
COPY apt /opt/docker-php-extensions/apt/intl
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-ext-install-deps \
      $(php-config --extension-dir)/intl.so \
      $(php-config --ini-dir)/docker-php-ext-intl.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
