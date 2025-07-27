ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# PHP 8.4+ doesn't bundle imap anymore; so we need to get it from PECL if not bundled.
RUN set -e; \
    docker-php-source extract; \
    if [ ! -d /usr/src/php/ext/imap ]; then \
      mkdir /usr/src/php/ext/imap; \
      curl https://pecl.php.net/get/imap-1.0.3.tgz | tar -C /usr/src/php/ext/imap -xzf - --strip-components 1; \
    fi

# Install
RUN apt-get update
RUN apt-get install -y libc-client2007e-dev libkrb5-dev libtls-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
COPY apt /opt/docker-php-extensions/apt/imap
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-ext-install-deps \
      $(php-config --extension-dir)/imap.so \
      $(php-config --ini-dir)/docker-php-ext-imap.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
