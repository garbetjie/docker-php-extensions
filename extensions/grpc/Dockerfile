ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/grpc
RUN curl https://pecl.php.net/get/grpc-1.70.0.tgz | tar -C /usr/src/php/ext/grpc -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y zlib1g-dev linux-headers-generic binutils
RUN docker-php-ext-install grpc
RUN strip --strip-debug /usr/local/lib/php/extensions/*-zts-*/grpc.so

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/grpc.so \
      $(php-config --ini-dir)/docker-php-ext-grpc.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
