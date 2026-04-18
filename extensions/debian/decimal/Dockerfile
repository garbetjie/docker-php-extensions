ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-trixie

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/decimal
RUN curl https://pecl.php.net/get/decimal-2.0.1.tgz | tar -C /usr/src/php/ext/decimal -xzf - --strip-components 1
COPY shell /tmp/install.sh
RUN bash /tmp/install.sh

# Install
RUN docker-php-ext-configure decimal
RUN docker-php-ext-install decimal

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
COPY shell /opt/docker-php-extensions/shell/decimal
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-ext-install-deps \
      $(php-config --extension-dir)/decimal.so \
      $(php-config --ini-dir)/docker-php-ext-decimal.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-trixie

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
