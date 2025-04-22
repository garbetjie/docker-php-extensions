ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/pdo_sqlsrv
RUN curl https://pecl.php.net/get/pdo_sqlsrv-5.12.0.tgz | tar -C /usr/src/php/ext/pdo_sqlsrv -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y unixodbc-dev gnupg
RUN docker-php-ext-install pdo_sqlsrv

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/pdo_sqlsrv
COPY shell /opt/docker-php-extensions/shell/pdo_sqlsrv
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pdo_sqlsrv.so \
      $(php-config --ini-dir)/docker-php-ext-pdo_sqlsrv.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
