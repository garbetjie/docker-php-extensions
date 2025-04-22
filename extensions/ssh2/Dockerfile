ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN apt-get update
RUN apt-get install -y libssh2-1-dev
RUN mkdir /usr/src/php/ext/ssh2
RUN curl https://pecl.php.net/get/ssh2-1.4.1.tgz | tar -C /usr/src/php/ext/ssh2 -xzf - --strip-components 1

# Install
RUN docker-php-ext-install ssh2

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/ssh2
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/ssh2.so \
      $(php-config --ini-dir)/docker-php-ext-ssh2.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
