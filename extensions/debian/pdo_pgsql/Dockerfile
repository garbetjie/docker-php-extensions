ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-trixie

# Unpack source
RUN docker-php-source extract

# Install
RUN apt-get update
RUN apt-get install -y libpq-dev
RUN docker-php-ext-install pdo_pgsql

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
COPY apt /opt/docker-php-extensions/apt/pdo_pgsql
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pdo_pgsql.so \
      $(php-config --ini-dir)/docker-php-ext-pdo_pgsql.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-trixie

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
