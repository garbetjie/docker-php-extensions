ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/protobuf
RUN curl https://pecl.php.net/get/protobuf-4.29.3.tgz | tar -C /usr/src/php/ext/protobuf -xzf - --strip-components 1

# Install
RUN docker-php-ext-install protobuf

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/protobuf.so \
      $(php-config --ini-dir)/docker-php-ext-protobuf.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
