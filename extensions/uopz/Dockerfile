ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/uopz
RUN curl https://pecl.php.net/get/uopz-7.1.1.tgz | tar -C /usr/src/php/ext/uopz -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure uopz --enable-uopz
RUN docker-php-ext-install uopz

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/uopz.so \
      $(php-config --ini-dir)/docker-php-ext-uopz.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
