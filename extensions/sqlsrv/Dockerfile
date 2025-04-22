ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/sqlsrv
RUN curl https://pecl.php.net/get/sqlsrv-5.12.0.tgz | tar -C /usr/src/php/ext/sqlsrv -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y unixodbc-dev gnupg
RUN docker-php-ext-install sqlsrv

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/sqlsrv
COPY shell /opt/docker-php-extensions/shell/sqlsrv
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/sqlsrv.so \
      $(php-config --ini-dir)/docker-php-ext-sqlsrv.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
